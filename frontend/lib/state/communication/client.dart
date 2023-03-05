import 'dart:isolate';

import 'package:grpc/grpc.dart';
import './grpc/trucking.pbgrpc.dart';

import './Backend.dart';
import 'dart:io';

import 'dart:convert';


void main() async{
  var json_string = await File("./example.json").readAsString();

  json_string = '{"nodes":[{"type":"junction","id":30,"position":{"x":-100.0,"y":-100.0}},{"type":"junction","id":31,"position":{"x":100.0,"y":100.0}},{"type":"depot","id":32,"position":{"x":-50.0,"y":50.0}}],"roads":[{"id":20,"start_node_id":30,"end_node_id":31,"length":282.842712474619},{"id":21,"start_node_id":31,"end_node_id":30,"length":282.842712474619}],"trucks":[{"id":10,"current_node":30,"current_road":null,"current_position":0.0,"route":[31],"start_time":0}],"globals":{"max_truck_acceleration":0.68,"max_truck_velocity":10.0,"sim_time":0.0}}';

  await startFromConfig(json_string);
  print('hi');
  for (int i = 0; i < 220; ++i){
    sleep(Duration(milliseconds:100));
    var data = await getPositionData((i + 0.0)/10);
    print(data);
  }
  return;
}

