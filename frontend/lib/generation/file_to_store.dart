import 'dart:ui';
import 'package:frontend/generation/store_state.dart';
import 'package:yaml/yaml.dart';

class StateParseException implements Exception {
  final String msg;

  const StateParseException(this.msg);

  @override
  String toString() => 'Exception while parsing yaml state file: $msg';
}

double numToDouble(num n) => n.toDouble();

StoreSimulationState loadFileIntoStoreState(String yamlData) {
  var data = loadYaml(yamlData);
  final vehicles = data['vehicles'];
  final roads = data['roads'];
  final nodes = data['nodes'];

  final Map<StoreRoadID, StoreRoad> roadMap = {};
  final Map<StoreVehicleID, StoreVehicle> vehicleMap = {};
  final Map<StoreNodeID, StoreNode> nodeMap = {};

  // vehicle
  for (MapEntry item in (vehicles as Map).entries) {
    var map = item.value as Map;
    vehicleMap[StoreVehicleID(item.key)] = (StoreVehicle(
      id: StoreVehicleID(item.key),
      node: map['node'] != null ? StoreNodeID(map['node']) : null,
      road: map['road'] != null ? StoreRoadID(map['road']) : null,
      fractionAlongRoad: numToDouble(map['fraction']),
      route: (map['route'] as List).map<StoreNodeID>((id) => StoreNodeID(id as int)).toList(),
    ));
  }

  // roads
  for (MapEntry item in (roads as Map).entries) {
    var map = item.value as Map;
    if (map['type'] == 'straight') {
      roadMap[StoreRoadID(item.key)] = (StoreStraightRoad(
        id: StoreRoadID(item.key),
        startNode: StoreNodeID(map['start node']),
        endNode: StoreNodeID(map['end node']),
      ));
    } else if (map['type'] == 'arc') {
      roadMap[StoreRoadID(item.key)] = (StoreArcRoad(
        id: StoreRoadID(item.key),
        centre: Offset(
          numToDouble(map['centre']['x']),
          numToDouble(map['centre']['y']),
        ),
        radius: numToDouble(map['radius']),
        startAngle: numToDouble(map['start angle']),
        sweepAngle: numToDouble(map['sweep angle']),
        startNode: StoreNodeID(map['start node']),
        endNode: StoreNodeID(map['end node']),
      ));
    }
  }

  // nodes
  for (MapEntry item in (nodes as Map).entries) {
    var map = item.value as Map;
    nodeMap[StoreNodeID(item.key)] = (StoreNode(
      id: StoreNodeID(item.key),
      position: Offset(
        numToDouble(map['position']['x']),
        numToDouble(map['position']['y']),
      ),
      capacity: map['capacity'],
      type: map['type'] == 'junction'
          ? StoreNodeType.junction
          : map['type'] == 'depot'
              ? StoreNodeType.depot
              : throw Exception(),
    ));
  }

  return StoreSimulationState(
    roadMap: roadMap,
    vehicleMap: vehicleMap,
    nodeMap: nodeMap,
  );
}
