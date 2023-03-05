import 'dart:convert';
import 'package:frontend/generation/store_state.dart';

// TODO: have frontend unconvert ID's back to non-globally unique form, rather than the backend

String? idToString(id) {
  if (id == null) {
    return null;
  } else if (id is StoreVehicleID) {
    return '1${id.value}';
  } else if (id is StoreRoadID) {
    return '2${id.value}';
  } else if (id is StoreNodeID) {
    return '3${id.value}';
  } else {
    throw Exception();
  }
}

String convertStoreStateToJson(StoreSimulationState state) {
  // the road, vehicle, and node IDs need to be globally unique
  // so just prepend each type with a different number
  final vehiclesJson = state.vehicleMap.values
      .map((StoreVehicle v) => {
            'id': idToString(v.id),
            // id mangling because backend only supports globally unique ids
            'current_node': idToString(v.node),
            'current_road': idToString(v.road),
            'current_position': v.fractionAlongRoad,
            'route': v.route.map((StoreNodeID id) => idToString(id)).toList(),
            'start_time': 0,
          })
      .toList();

  final roadsJson = state.roadMap.values
      .map((StoreRoad r) => {
            'id': idToString(r.id),
            'start_node_id': idToString(r.startNode),
            'end_node_id': idToString(r.endNode),
            'length': (state.nodeMap[r.endNode]!.position -
                    state.nodeMap[r.startNode]!.position)
                .distance,
          })
      .toList();

  final nodesJson = state.nodeMap.values
      .map((StoreNode n) => {
            'type': n.type == StoreNodeType.depot
                ? 'depot'
                : n.type == StoreNodeType.junction
                    ? 'junction'
                    : '<ERROR: a new node type was added in the enum, but not added to the JSON serialisation code>',
            'id': idToString(n.id),
            'position': {
              'x': n.position.dx,
              'y': n.position.dy,
            },
          })
      .toList();
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
