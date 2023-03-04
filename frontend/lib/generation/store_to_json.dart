import 'dart:convert';
import 'package:frontend/generation/store_state.dart';

String convertStoreStateToJson(StoreSimulationState state) {
  // the road, vehicle, and node IDs need to be globally unique
  // so just prepend each type with a different number
  final vehiclesJson = state.vehicleMap.values.map((StoreVehicle v) => {
        'id': '1${v.id.value}', // id mangling because backend only supports globally unique ids
        'current_node': v.node?.value,
        'current_road': v.road?.value,
        'current_position': v.fractionAlongRoad,
        'route': v.route.map((StoreNodeID id) => id.value),
        'start_time': 0,
      });

  final roadsJson = state.roadMap.values.map((StoreRoad r) => {
        'id': "2${r.id.value}",
        'start_node_id': r.startNode.value,
        'end_node_id': r.endNode.value,
        'length': (state.nodeMap[r.endNode]!.position -
                state.nodeMap[r.startNode]!.position)
            .distance,
      });

  final nodesJson = state.nodeMap.values.map((StoreNode n) => {
        'type': n.type == StoreNodeType.depot
            ? 'depot'
            : n.type == StoreNodeType.junction
                ? 'junction'
                : '<ERROR: a new node type was added in the enum, but not added to the JSON serialisation code>',
        'id': '3${n.id.value}',
        'position': {
          'x': n.position.dx,
          'y': n.position.dy,
        },
      });
  final dataJson = {
    'nodes': nodesJson,
    'roads': roadsJson,
    'trucks': vehiclesJson,
    'globals': {
      'max_truck_acceleration': 0.68,
      "max_truck_velocity": 10.0,
      'sim_time': 0.0,
    }
  };
  return jsonEncode(dataJson);
}
