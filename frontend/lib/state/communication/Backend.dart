import 'dart:isolate';

import 'package:grpc/grpc.dart';
import './grpc/trucking.pbgrpc.dart';

// so far no error checking

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
  // will throw error if server not yet started/up
    final response = await _PositionDataStreamerStub.getPositionData(
        delta);

  return response;

}

Future<List<TruckPositionsAtTime>> getPositionData(double timeStamp) async{
  // could be if assuming timeStamps will never "skip" a full buffer worth of data
  while (timeStamp > _buffer.trucks.last.time){
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

  // might not be needed - only relevant in case very first buffer's entry has smallest time-slot greater than 0 (should not happen)
  else if(_lastBufferPtr == 0){
    return [_buffer.trucks[0]];
  }
  // work for interpolator function!
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

/* TODO: after MVP is finished, add start from config (includes adding/removing vehicles)
*  and allow change of params including vehicle position and destination
* (need to know backend data structures for that)
*/
