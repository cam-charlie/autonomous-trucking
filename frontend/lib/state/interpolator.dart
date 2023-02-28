import 'dart:math';

import 'package:flutter/material.dart';

import 'package:frontend/state/road.dart';
import 'package:frontend/state/simulation.dart';
import 'package:frontend/state/vehicle.dart';
import 'package:collection/collection.dart';

import 'communication/Backend.dart';
import 'package:grpc/grpc.dart';
import 'communication/grpc/trucking.pbgrpc.dart';
// import 'faketrucking.dart';

// Dart doesn't implement pairs, must do so myself
class _Result {
  final bool roadChange;
  final double fracDist;
  const _Result({required this.fracDist}) : roadChange = fracDist > 1;
}

class _Interpolator {
  final List<RenderRoad> _roads;
  final Map<RID, RenderRoad> _roadMap;
  final Map<VID, bool> _turn;
  final Map<VID, double> _speed;
  final Function(double time) _getData;
  CommunicationLog comms;

  _Interpolator(
      {required List<RenderRoad> roads,
      required dynamic Function(double) getData})
      : _roads = roads,
        _getData = getData,
        _roadMap = {for (var road in roads) road.id: road},
        _turn = {},
        _speed = {},
        comms = CommunicationLog();

  // Generate logs while computing interpolated results
  _Result _calculateAndLog(Truck start, Truck end, double t0, double ti,
      double t1, Map<RID, RenderRoad> map) {
    double fracDist = _truckFracDistCovered(start, end, t0, ti, t1, map);

    if (!_turn.containsKey(VID(start.truckId))) {
      comms.add(InitAction(vehicle: VID(start.truckId), time: t0));
      _turn[VID(start.truckId)] = false;
      _speed[VID(start.truckId)] = start.currSpeed;
    } else if (fracDist > 1 && !(_turn[VID(start.truckId)]!)) {
      // Claculate direction of turn

      double startDir = CalculationRoad.direction(map[RID(start.roadId)]!,
          fraction: start.progress);
      double endDir = CalculationRoad.direction(map[RID(end.roadId)]!,
          fraction: fracDist % 1.0);

      Vector3 calcVec = Vector3(sin(startDir), cos(startDir), 0)
          .cross(Vector3(sin(endDir), cos(endDir), 0));
      Direction dir;

      if (calcVec.z.abs() < sin(pi / 36)) {
        dir = Direction.straight;
      } else if (calcVec.z < 0) {
        dir = Direction.right;
      } else {
        dir = Direction.left;
      }

      comms.add(TurnAction(
          vehicle: VID(start.truckId),
          time: ti,
          startRoad: RID(start.roadId),
          endRoad: RID(end.roadId),
          direction: dir));
      _turn[VID(start.truckId)] = true;
    } else if (fracDist <= 1 && _turn[VID(start.truckId)]!) {
      _turn[VID(start.truckId)] = false;
    }

    if (_speed[VID(start.truckId)]! != end.currSpeed) {
      double speed = _speed[VID(start.truckId)]!;
      comms.add(ChangeSpeedAction(
          vehicle: VID(start.truckId),
          time: t0,
          startSpeed: speed,
          endSpeed: end.currSpeed));
      _speed[VID(start.truckId)] = end.currSpeed;
    }

    return _Result(fracDist: fracDist);
  }

  // Find the % of start road covered, increment to beyond 100% if road change
  double _truckFracDistCovered(Truck start, Truck end, double t0, double ti,
      double t1, Map<RID, RenderRoad> map) {
    double juncDist = start.roadId == end.roadId
        ? double.infinity
        : (1 - start.progress) *
            CalculationRoad.length(map[RID(start.roadId)]!);
    // Assumes jerk is constant between two points
    double interDist = start.currSpeed * (ti - t0) +
        0.5 * start.currAccel * pow((ti - t0), 2) +
        (((end.currAccel - start.currAccel) / (t1 - t0)) * pow((ti - t0), 3)) /
            6;
    double fracDist = interDist < juncDist
        ? start.progress +
            interDist / CalculationRoad.length(map[RID(start.roadId)]!)
        : 1 +
            (interDist - juncDist) /
                CalculationRoad.length(map[RID(end.roadId)]!);

    return fracDist;
  }

  // Determine if truck has switched between raod A and road B
  /*
  bool _truckRoadChange(Truck start, Truck end, double t0, double ti, double t1,
      Map<RID, RenderRoad> map) {
    return _truckFracDistCovered(start, end, t0, ti, t1, map) > 1;
  }
  */

  // Generates new SimulationState for rendering
  Future<SimulationState> getState(double time) async {
    List<TruckPositionsAtTime> positions = await _getData(time);

    // time == generated time t0, state matches generation

    if (positions.length == 1) {
      List<Vehicle> vehicles = positions[0]
          .trucks
          .map((e) => Vehicle(
              id: VID(e.truckId),
              position: CalculationRoad.positionAt(_roadMap[RID(e.roadId)]!,
                  fraction: e.progress),
              direction: CalculationRoad.direction(_roadMap[RID(e.roadId)]!,
                  fraction: e.progress)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: _roads);
    }

    // time != generated time t0, tomfoolery ensues
    else {
      // Pre calculate distances
      Iterable<_Result> results =
          IterableZip([positions[0].trucks, positions[1].trucks])
              .map((e) => _calculateAndLog(e[0], e[1], positions[0].time, time,
                  positions[1].time, _roadMap))
              .toList();

      List<Vehicle> vehicles = IterableZip([
        positions[0].trucks as List<Truck>,
        positions[1].trucks as List<Truck>,
        results as List<_Result>
      ])
          .map((e) => Vehicle(
              id: VID((e[0] as Truck).truckId),
              position: CalculationRoad
                  .positionAt(_roadMap[RID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!,
                      fraction: (e[2] as _Result).fracDist > 1.0
                          ? (e[2] as _Result).fracDist - 1.0
                          : (e[2] as _Result).fracDist),
              direction: CalculationRoad.direction(
                      _roadMap[RID(
                          (e[(e[2] as _Result).roadChange ? 1 : 0] as Truck)
                              .roadId)]!,
                      fraction: ((e[2] as _Result).fracDist > 1.0
                          ? (e[2] as _Result).fracDist - 1.0
                          : (e[2] as _Result).fracDist)) %
                  (2 * pi)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: _roads);
    }
  }
}

class Interpolator extends _Interpolator {
  Interpolator({roads}) : super(roads: roads, getData: getPositionData);
}

@visibleForTesting
class TestInterpolator extends _Interpolator {
  TestInterpolator({roads, getData}) : super(roads: roads, getData: getData);
}
