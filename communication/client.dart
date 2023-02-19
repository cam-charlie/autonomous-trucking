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

