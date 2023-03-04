import 'dart:isolate';

import 'package:grpc/grpc.dart';
import './grpc/trucking.pbgrpc.dart';

import './Backend.dart';
import 'dart:io';

import 'dart:convert';


void main() async{
  var json_string = await File("./example.json").readAsString();

  await startFromConfig(json_string);
  print('hi');
  for (int i = 0; i < 220; ++i){
    sleep(Duration(milliseconds:100));
    var data = await getPositionData((i + 0.0)/10);
    print(data);
  }
  return;
}

