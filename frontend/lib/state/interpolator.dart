import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/state/road.dart';
import 'package:frontend/state/road_calculation.dart' as road_calc;
import 'package:frontend/state/simulation.dart';
import 'package:frontend/state/vehicle.dart';
import 'package:collection/collection.dart';

import 'communication/Backend.dart';
import 'package:grpc/grpc.dart';
import 'communication/grpc/trucking.pbgrpc.dart';

// Dart doesn't implement pairs, must do so myself
class _Result {
  final bool roadChange;
  final double fracDist;
  const _Result({required this.fracDist}) : roadChange = fracDist > 1;
}

class _Interpolator {
  final List<RenderRoad> roads;
  final Map<RID, RenderRoad> _roadMap;
  Function(double time) getData;

  _Interpolator({required this.roads, required this.getData})
      : _roadMap = {for (var road in roads) road.id: road} {}

  // Find the % of start road covered, increment to beyond 100% if road change
  double _truckFracDistCovered(Truck start, Truck end, double t0, double ti,
      double t1, Map<RID, RenderRoad> map) {
    double juncDist = start.roadId == end.roadId
        ? double.infinity
        : (1 - start.progress) *
            road_calc.length(map[RID(start.roadId)]!);
    // Assumes jerk is constant between two points
    double interDist = start.currSpeed * (ti - t0) +
        0.5 * start.currAccel * pow((ti - t0), 2) +
        (((end.currAccel - start.currAccel) / (t1 - t0)) * pow((ti - t0), 3)) /
            6;
    double fracDist = interDist < juncDist
        ? start.progress +
            interDist / road_calc.length(map[RID(start.roadId)]!)
        : 1 +
            (interDist - juncDist) /
                road_calc.length(map[RID(end.roadId)]!);

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
    List<TruckPositionsAtTime> positions = await getData(time);

    // time == generated time t0, state matches generation

    if (positions.length == 1) {
      List<Vehicle> vehicles = positions[0]
          .trucks
          .map((e) => Vehicle(
              id: VID(e.truckId),
              position: road_calc.positionAt(_roadMap[RID(e.roadId)]!,
                  fraction: e.progress),
              direction: road_calc.direction(_roadMap[RID(e.roadId)]!,
                  fraction: e.progress)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
    }

    // time != generated time t0, tomfoolery ensues
    else {
      // Pre calculate distances
      Iterable<_Result> results =
          IterableZip([positions[0].trucks, positions[1].trucks])
              .map((e) => _Result(
                  fracDist: _truckFracDistCovered(e[0], e[1], positions[0].time,
                      time, positions[1].time, _roadMap)))
              .toList();

      List<Vehicle> vehicles = IterableZip([
        positions[0].trucks,
        positions[1].trucks,
        results as List<_Result>
      ])
          .map((e) => Vehicle(
              id: VID((e[0] as Truck).truckId),
              position: road_calc
                  .positionAt(_roadMap[RID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!,
                      fraction: (e[2] as _Result).fracDist > 1.0
                          ? (e[2] as _Result).fracDist - 1.0
                          : (e[2] as _Result).fracDist),
              direction: road_calc.direction(
                      _roadMap[RID(
                          (e[(e[2] as _Result).roadChange ? 1 : 0] as Truck)
                              .roadId)]!,
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
