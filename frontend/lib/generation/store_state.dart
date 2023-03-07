import 'dart:ui';

import 'package:equatable/equatable.dart';

/// This takes in a road network config (file/class?), and generates both
/// the cartesian RenderRoad code and the graph data structure,
/// and the mapping between the two

class StoreSimulationState {
  final Map<StoreRoadID, StoreRoad> roadMap;
  final Map<StoreVehicleID, StoreVehicle> vehicleMap;
  final Map<StoreNodeID, StoreNode> nodeMap;

  StoreSimulationState({
    required this.roadMap,
    required this.vehicleMap,
    required this.nodeMap,
  });
}

class StoreRoadID extends Equatable {
  final int value;

  const StoreRoadID(this.value);

  @override
  List<Object?> get props => [value];
}

abstract class StoreRoad {
  StoreRoadID get id;

  StoreNodeID get startNode;

  StoreNodeID get endNode;

  const StoreRoad();
}

class StoreArcRoad extends StoreRoad {
  @override
  final StoreRoadID id;
  final Offset centre;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  @override
  final StoreNodeID startNode;
  @override
  final StoreNodeID endNode;

  const StoreArcRoad({
    required this.id,
    required this.centre,
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
    required this.startNode,
    required this.endNode,
  });
}

class StoreStraightRoad extends StoreRoad {
  @override
  final StoreRoadID id;
  @override
  final StoreNodeID startNode;
  @override
  final StoreNodeID endNode;

  const StoreStraightRoad({
    required this.id,
    required this.startNode,
    required this.endNode,
  });
}

class StoreVehicleID extends Equatable {
  final int value;

  const StoreVehicleID(this.value);

  @override
  List<Object?> get props => [value];
}

class StoreVehicle {
  final StoreVehicleID id;
  final StoreNodeID? node;
  final StoreRoadID? road;
  final double? fractionAlongRoad;
  final List<StoreNodeID> route;

  const StoreVehicle({
    required this.id,
    required this.node,
    required this.road,
    required this.fractionAlongRoad,
    required this.route,
  });
}

class StoreNodeID extends Equatable {
  final int value;

  const StoreNodeID(this.value);

  @override
  List<Object?> get props => [value];
}

enum StoreNodeType { junction, depot }

class StoreNode {
  final StoreNodeID id;
  final Offset position;
  final int? capacity;
  final StoreNodeType type;

  const StoreNode(
      {required this.id,
      required this.position,
      required this.capacity,
      required this.type});
}
