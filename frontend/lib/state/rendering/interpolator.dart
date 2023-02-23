import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/state/rendering/road.dart';
import 'package:frontend/state/rendering/simulation.dart';
import 'package:frontend/state/rendering/vehicle.dart';
import 'package:collection/collection.dart';
import 'faketrucking.dart';

// Dart doesn't implement pairs, must do so myself
class _Result {
  final bool roadChange;
  final double fracDist;
  const _Result({required this.roadChange, required this.fracDist});
}

class _Interpolator {
  final List<RenderRoad> roads;
  final Map<RID, RenderRoad> _roadMap;
  Function(double time) getData;

  _Interpolator({required this.roads, required this.getData})
      : _roadMap = {for (var road in roads) road.id: road};

  // Find the % of start road covered, increment to beyond 100% if road change
  double _truckFracDistCovered(Truck start, Truck end, double t0, double ti,
      double t1, Map<RID, RenderRoad> map) {
    double juncDist = start.roadId == end.roadId
        ? double.infinity
        : (1 - start.progress) * map[RID(start.roadId)]!.length;
    // Assumes jerk is constant between two points
    double interDist = start.currSpeed * (ti - t0) +
        0.5 * start.currAccel * pow((ti - t0), 2) +
        (((end.currAccel - start.currAccel) / (t1 - t0)) * pow((ti - t0), 3)) /
            6;
    double fracDist = interDist < juncDist
        ? start.progress + interDist / map[RID(start.roadId)]!.length
        : 1 + (interDist - juncDist) / map[RID(end.roadId)]!.length;

    return fracDist;
  }

  // Determine if truck has switched between raod A and road B

  bool _truckRoadChange(Truck start, Truck end, double t0, double ti, double t1,
      Map<RID, RenderRoad> map) {
    return _truckFracDistCovered(start, end, t0, ti, t1, map) > 1;
  }

  // Generates new SimulationState for rendering
  Future<SimulationState> getState(double time) async {
    List<TruckPositionsAtTime> positions = await getData(time);

    // time == generated time t0, state matches generation

    if (positions.length == 1) {
      List<Vehicle> vehicles = positions[0]
          .trucks
          .map((e) => Vehicle(
              id: VID(e.truckId),
              position:
                  _roadMap[RID(e.roadId)]!.positionAt(fraction: e.progress),
              direction:
                  _roadMap[RID(e.roadId)]!.direction(fraction: e.progress)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
    }

    // time != generated time t0, tomfoolery ensues
    else {
      // Pre calculate distances
      Iterable<_Result> results =
          IterableZip([positions[0].trucks, positions[1].trucks]).map((e) =>
              _Result(
                  roadChange: _truckRoadChange(e[0], e[1], positions[0].time,
                      time, positions[1].time, _roadMap),
                  fracDist: _truckFracDistCovered(e[0], e[1], positions[0].time,
                      time, positions[1].time, _roadMap)));

      List<Vehicle> vehicles = IterableZip(
              [positions[0].trucks, positions[1].trucks, results])
          .map((e) => Vehicle(
              id: VID((e[0] as Truck).truckId),
              position: _roadMap[RID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!
                  .positionAt(
                      fraction: (e[2] as _Result).fracDist > 1.0
                          ? (e[2] as _Result).fracDist - 1.0
                          : (e[2] as _Result).fracDist),
              direction:
                  _roadMap[RID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!
                          .direction(
                              fraction: ((e[2] as _Result).fracDist > 1.0
                                  ? (e[2] as _Result).fracDist - 1.0
                                  : (e[2] as _Result).fracDist)) %
                      (2 * pi)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
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
