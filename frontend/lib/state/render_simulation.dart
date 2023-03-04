import 'package:frontend/state/render_road.dart';
import 'package:collection/collection.dart';

import 'render_vehicle.dart';

class RenderSimulationState {
  final List<RenderVehicle> vehicles;
  final List<RenderRoad> roads;

  const RenderSimulationState({required this.vehicles, required this.roads});

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(vehicles), Object.hashAll(roads));

  @override
  bool operator ==(Object other) {
    return (other is RenderSimulationState) &&
        const ListEquality().equals(vehicles, other.vehicles) &&
        const ListEquality().equals(roads, other.roads);
  }
}
