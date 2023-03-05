import '../render_vehicle.dart';
import '../render_road.dart';
import 'package:sprintf/sprintf.dart';

class CommunicationLog {
  static final CommunicationLog _instance = CommunicationLog._internal();
  static List<_Action> _log = [];
  CommunicationLog._internal();
  factory CommunicationLog() => _instance;
  void add(_Action action) => _log.add(action);
  void clear() => _log.clear();
  @override
  String toString() {
    String out = "";
    for (var log in _log) {
      out += log.toString() + "\n";
    }
    return out;
  }
}

class _Action {
  final RenderVehicleID vehicle;
  final double time;
  _Action({required this.vehicle, required this.time});
  @override
  String toString() {
    return sprintf("%2.2f: ", [time]);
  }
}

enum Direction { left, right, straight }

class TurnAction extends _Action {
  final RenderRoadID startRoad;
  final RenderRoadID endRoad;
  final RenderVehicleID vehicle;
  final double time;
  final Direction direction;
  TurnAction(
      {required this.vehicle,
      required this.time,
      required this.startRoad,
      required this.endRoad,
      required this.direction})
      : super(time: time, vehicle: vehicle);
  @override
  String toString() {
    return super.toString() +
        sprintf("%s has %s onto %s (%s -> %s)", [
          vehicle.toString(),
          direction == Direction.left
              ? "turned left"
              : direction == Direction.right
                  ? "turned right"
                  : "continued",
          endRoad.toString(),
          startRoad.toString(),
          endRoad.toString()
        ]);
  }
}

class ChangeSpeedAction extends _Action {
  final double startSpeed;
  final double endSpeed;
  final RenderVehicleID vehicle;
  final double time;
  ChangeSpeedAction(
      {required this.vehicle,
      required this.time,
      required this.startSpeed,
      required this.endSpeed})
      : super(time: time, vehicle: vehicle);
  @override
  String toString() {
    return super.toString() +
        sprintf("%s is changing speed ", [vehicle.toString()]) +
        sprintf("(%2.2f -> %2.2f)", [startSpeed, endSpeed]);
  }
}

class InitAction extends _Action {
  final RenderVehicleID vehicle;
  final double time;
  InitAction({required this.vehicle, required this.time})
      : super(time: time, vehicle: vehicle);
  @override
  String toString() {
    return super.toString() +
        sprintf("Vehicle %s has started moving ()", [vehicle.toString()]);
  }
}

class DepotAction extends _Action {
  final bool enter;
  final RenderVehicleID vehicle;
  final double time;
  DepotAction({required this.vehicle, required this.time, required this.enter})
      : super(time: time, vehicle: vehicle);
  @override
  String toString() {
    return super.toString() +
        sprintf("%s has %s a depot",
            [vehicle.toString(), enter ? "entered" : "left"]);
  }
}
