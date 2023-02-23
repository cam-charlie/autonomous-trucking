import 'package:frontend/state/rendering/road.dart';
import 'package:collection/collection.dart';

import 'vehicle.dart';

class SimulationState {
  final List<Vehicle> vehicles;
  final List<RenderRoad> roads;

  const SimulationState({required this.vehicles, required this.roads});

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(vehicles), Object.hashAll(roads));

  @override
  bool operator ==(Object other) {
    return (other is SimulationState) &&
        const ListEquality().equals(vehicles, other.vehicles) &&
        const ListEquality().equals(roads, other.roads);
  }
}
