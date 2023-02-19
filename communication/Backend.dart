import 'dart:isolate';

import 'package:grpc/grpc.dart';
import './trucking.pbgrpc.dart';

// so far no error checking

//class Truck{
//  int truck_id;
//  int destination_id;
//  double curr_speed;
//  int road_id;
//  // from 0 to 100 (indicating percentage along that road)
//  double progress;
//
//  Truck(this.truck_id, this.destination_id, this.curr_speed, this.road_id, this.progress);
//}

final _channel = ClientChannel(
  'localhost',
  port: 50051,
  options: ChannelOptions(
    credentials: ChannelCredentials.insecure(), // do not use authentication ==> should use in case we scale up to multiple machines!
    codecRegistry:
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  ),
);

final _PositionDataStreamerStub = PositionDataStreamerClient(_channel);

var _buffer = null;
int _lastBufferPtr = 0;
var _nextBufferFiller;

Future<void> _fillFirstBuffer() async{
  _buffer = await _getBufferData();
  _nextBufferFiller = Isolate.run(_getBufferData);
}

_getBufferData() async{
  var delta = TimeDelta(seconds: 3.0);
  // will throw error if server not yet started
  final response = await _PositionDataStreamerStub.getPositionData(
      delta);
  //options: CallOptions(compression: const GzipCodec()),
  return response;

}

Future<List<TruckPositionsAtTime>> getPositionData(double timeStamp) async{
  // could be if assuming timeStamps will never "skip" a full buffer worth of data
  while (timeStamp > _buffer.trucks.last.time){
    //var tmp = _secondBuffer;
    // should already have the data!
    var tmp = _buffer;
    _buffer = await _nextBufferFiller;

    _buffer.trucks.insert(0, tmp.trucks.last);

    _lastBufferPtr = 0;
    _nextBufferFiller = Isolate.run(_getBufferData);
  }

  while (_buffer.trucks[_lastBufferPtr].time < timeStamp){
    _lastBufferPtr++;
  }

  // perfect match!
  if (_buffer.trucks[_lastBufferPtr].time == timeStamp){
    return [_buffer.trucks[_lastBufferPtr]];
  }

  // might not be needed
  else if(_lastBufferPtr == 0){
    return [_buffer.trucks[0]];
  }
  // work for interpolater function!
  else {
    // this fails if, on the very first buffer frontend receives, we do not start with timeStamp 0
    assert (_lastBufferPtr > 0);
    return [_buffer.trucks[_lastBufferPtr - 1], _buffer.trucks[_lastBufferPtr]];
  }
}


Future<void> startFromConfig(var config) async {
  // for now ignore config, just start
  await _fillFirstBuffer();
}


//Future<double> doStuff() async{
//  try {
//    var delta = TimeDelta(seconds:3.0);
//    final response = _PositionDataStreamerStub.getPositionData(
//      delta,
//      options: CallOptions(compression: const GzipCodec()),
//    );
//    //for (int i = 0; i < 5000000; i++){
//    //  print(i);
//    //}
//    var res = await response;
//    // sleep(Duration(seconds:7));
//
//    print('slept!');
//    return res.trucks[0].time;
//    for (var t in res.trucks){
//      print(t.time);
//    }
//   } catch (e) {
//    print('Caught error: $e');
//  }
//  return 0;
//}