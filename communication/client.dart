import 'dart:isolate';

import 'package:grpc/grpc.dart';
import './trucking.pbgrpc.dart';

import './Backend.dart';
import 'dart:io';


void main() async{
  await startFromConfig(1);
  print('hi');
  for (int i = 0; i < 220; ++i){
    sleep(Duration(milliseconds:100));
    var data = await getPositionData((i + 0.0)/10);
    print(data);
  }
  return;
}





//void main(List<String> args) async {
//  //final channel = ClientChannel(
//  //  'localhost',
//  //  port: 50051,
//  //  options: ChannelOptions(
//  //    credentials: ChannelCredentials.insecure(), // do not use authentication ==> should use in case we scale up to multiple machines!
//  //    codecRegistry:
//  //    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
//  //  ),
//  //);
//
//  //var chan = channel;
//
//  //final stub = PositionDataStreamerClient(channel);
//
//  print("lol");
//  final i = Isolate.run(doStuff);
//  sleep(Duration(seconds:10));
//  print('slept!Outer');
//  final res = await i;
//  print(res);
//
//
//
//  //try {
//  //  var delta = TimeDelta(seconds:3.0);
//  //  final response = stub.getPositionData(
//  //    delta,
//  //    options: CallOptions(compression: const GzipCodec()),
//  //  );
//  //  //for (int i = 0; i < 5000000; i++){
//  //  //  print(i);
//  //  //}
//  //  var res = await response;
//  //  // sleep(Duration(seconds:7));
//
//  //  print('slept!');
//  //  for (var t in res.trucks){
//  //    print(t.time);
//  //  }
//  //} catch (e) {
//  //  print('Caught error: $e');
//  //}
//  //await channel.shutdown();
//}
//
//
//
//