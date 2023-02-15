import 'package:frontend/state/road.dart';
import 'package:frontend/state/vehicle.dart';

class SimulationState {
  final List<Vehicle> vehicles;
  final List<Road> roads;

  const SimulationState({required this.vehicles, required this.roads});
}

