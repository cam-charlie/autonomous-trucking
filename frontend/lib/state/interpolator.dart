import 'dart:math';

import 'package:frontend/state/communication/comm_log.dart';
import 'package:frontend/state/render_depot.dart';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/material.dart';

import 'package:frontend/state/render_road.dart';
import 'package:frontend/state/road_calculation.dart' as road_calc;
import 'package:frontend/state/render_simulation.dart';
import 'package:frontend/state/render_vehicle.dart';
import 'package:collection/collection.dart';

import 'communication/Backend.dart';
import 'communication/grpc/trucking.pbgrpc.dart';

// Dart doesn't implement pairs, must do so myself
class _Result {
  final bool roadChange;
  final double fracDist;

  const _Result({required this.fracDist}) : roadChange = fracDist > 1;
}

class Buffering {
  bool buffering;
  Future<RenderSimulationState> state;

  Buffering({required double time, required _Interpolator interpolator})
      : buffering = isBufferingOnTimestamp(time),
        state = interpolator.getState(time);
}

class _Interpolator {
  final List<RenderRoad> _roads;
  final List<RenderDepot> _depots;
  final Map<RenderRoadID, RenderRoad> _roadMap;
  final Map<RenderVehicleID, bool> _turn;
  final Map<RenderVehicleID, double> _speed;
  final Map<RenderVehicleID, bool> _depoted;
  final Function(double time) _getData;
  CommunicationLog comms;

  _Interpolator(
      {required List<RenderRoad> roads,
      required List<RenderDepot> depots,
      required dynamic Function(double) getData})
      : _roads = roads,
        _depots = depots,
        _getData = getData,
        _roadMap = {for (var road in roads) road.id: road},
        _turn = {},
        _speed = {},
        _depoted = {},
        comms = CommunicationLog();

  // Generate logs while computing interpolated results
  _Result _calculateAndLog(Truck start, Truck end, double t0, double ti,
      double t1, Map<RenderRoadID, RenderRoad> map) {
    // In depot?
    if (start.progress == -1 && end.progress == -1) {
      if (!_depoted.containsKey(RenderVehicleID(start.truckId))) {
        _depoted[RenderVehicleID(start.truckId)] = true;
      }
      return const _Result(fracDist: -1);
    }

    double fracDist = _truckFracDistCovered(start, end, t0, ti, t1, map);

    // Entering depot?
    if (fracDist == -1 && !_depoted[RenderVehicleID(start.truckId)]!) {
      comms.add(DepotAction(
          vehicle: RenderVehicleID(start.truckId),
          time: ti,
          depot: RenderDepotID(end.roadId),
          enter: true));
      _depoted[RenderVehicleID(start.truckId)] = true;
      return const _Result(fracDist: -1);
    }

    // Leaving depot?
    if (fracDist > 0 && _depoted[RenderVehicleID(start.truckId)]!) {
      comms.add(DepotAction(
          vehicle: RenderVehicleID(start.truckId),
          time: ti,
          depot: RenderDepotID(end.roadId),
          enter: false));
      _depoted[RenderVehicleID(start.truckId)] = false;
      return _Result(fracDist: fracDist);
    }

    if (!_turn.containsKey(RenderVehicleID(start.truckId))) {
      comms.add(InitAction(vehicle: RenderVehicleID(start.truckId), time: t0));
      _turn[RenderVehicleID(start.truckId)] = false;
      _speed[RenderVehicleID(start.truckId)] = start.currSpeed;
    } else if (fracDist > 1 && !(_turn[RenderVehicleID(start.truckId)]!)) {
      // Claculate direction of turn

      double startDir = road_calc.direction(map[RenderRoadID(start.roadId)]!,
          fraction: start.progress);
      double endDir = road_calc.direction(map[RenderRoadID(end.roadId)]!,
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
          vehicle: RenderVehicleID(start.truckId),
          time: ti,
          startRoad: RenderRoadID(start.roadId),
          endRoad: RenderRoadID(end.roadId),
          direction: dir));
      _turn[RenderVehicleID(start.truckId)] = true;
    } else if (fracDist <= 1 && _turn[RenderVehicleID(start.truckId)]!) {
      _turn[RenderVehicleID(start.truckId)] = false;
    }

    if (_speed[RenderVehicleID(start.truckId)]! != end.currSpeed) {
      double speed = _speed[RenderVehicleID(start.truckId)]!;
      comms.add(ChangeSpeedAction(
          vehicle: RenderVehicleID(start.truckId),
          time: t0,
          startSpeed: speed,
          endSpeed: end.currSpeed));
      _speed[RenderVehicleID(start.truckId)] = end.currSpeed;
    }

    return _Result(fracDist: fracDist);
  }

  // Find the % of start road covered, increment to beyond 100% if road change
  double _truckFracDistCovered(Truck start, Truck end, double t0, double ti,
      double t1, Map<RenderRoadID, RenderRoad> map) {
    if (start.progress != -1) {
      double juncDist = start.roadId == end.roadId
          ? double.infinity
          : (1 - start.progress) *
              road_calc.length(map[RenderRoadID(start.roadId)]!);
      // Assumes jerk is constant between two points
      double interDist = start.currSpeed * (ti - t0) +
          0.5 * start.currAccel * pow((ti - t0), 2) +
          (((end.currAccel - start.currAccel) / (t1 - t0)) *
                  pow((ti - t0), 3)) /
              6;
      double fracDist = interDist < juncDist
          ? start.progress +
              interDist / road_calc.length(map[RenderRoadID(start.roadId)]!)
          : end.progress == -1
              ? -1
              : (1 +
                  (interDist - juncDist) /
                      road_calc.length(map[RenderRoadID(end.roadId)]!));

      return fracDist;
    } else {
      // Cannot be certain of trucks behaviour leaving depot
      // Will model as linear for time being
      double timeTilOut = road_calc.length(map[RenderRoadID(end.roadId)]!) *
          end.progress /
          end.currSpeed;
      return ti - t0 < timeTilOut
          ? -1
          : 1 +
              (((ti - (t0 + timeTilOut)) * end.currSpeed) /
                  road_calc.length(map[RenderRoadID(end.roadId)]!));
    }
  }

  // Determine if truck has switched between raod A and road B
  /*
  bool _truckRoadChange(Truck start, Truck end, double t0, double ti, double t1,
      Map<RID, RenderRoad> map) {
    return _truckFracDistCovered(start, end, t0, ti, t1, map) > 1;
  }
  */
  Buffering getBufferingState(double time) {
    return Buffering(time: time, interpolator: this);
  }

  // Generates new SimulationState for rendering

  Future<RenderSimulationState> getState(double time) async {
    List<TruckPositionsAtTime> positions = await _getData(time);

    // time == generated time t0, state matches generation

    if (positions.length == 1) {
      List<RenderVehicle> vehicles = positions[0]
          .trucks
          .map((e) => e.progress != -1
              ? RenderVehicle(
                  id: RenderVehicleID(e.truckId),
                  position: road_calc.positionAt(
                      _roadMap[RenderRoadID(e.roadId)]!,
                      fraction: e.progress),
                  direction: road_calc.direction(
                      _roadMap[RenderRoadID(e.roadId)]!,
                      fraction: e.progress))
              : Null)
          .whereType<RenderVehicle>()
          .toList();
      return RenderSimulationState(
          vehicles: vehicles, roads: _roads, depots: _depots);
    }

    // time != generated time t0, tomfoolery ensues
    else {
      // Pre calculate distances
      Iterable<_Result> results =
          IterableZip([positions[0].trucks, positions[1].trucks])
              .map((e) => _calculateAndLog(e[0], e[1], positions[0].time, time,
                  positions[1].time, _roadMap))
              .toList();

      List<RenderVehicle> vehicles = IterableZip(
              [positions[0].trucks, positions[1].trucks, results as List<_Result>])
          .map((e) => (e[2] as _Result).fracDist == -1
              ? Null
              : RenderVehicle(
                  id: RenderVehicleID((e[0] as Truck).truckId),
                  position: road_calc.positionAt(_roadMap[RenderRoadID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!,
                      fraction: (e[2] as _Result).fracDist > 1.0
                          ? (e[2] as _Result).fracDist - 1.0
                          : (e[2] as _Result).fracDist),
                  direction:
                      road_calc.direction(_roadMap[RenderRoadID((e[(e[2] as _Result).roadChange ? 1 : 0] as Truck).roadId)]!,
                              fraction: ((e[2] as _Result).fracDist > 1.0
                                  ? (e[2] as _Result).fracDist - 1.0
                                  : (e[2] as _Result).fracDist)) %
                          (2 * pi)))
          .whereType<RenderVehicle>()
          .toList();
      return RenderSimulationState(
          vehicles: vehicles, roads: _roads, depots: _depots);
    }
  }
}

class Interpolator extends _Interpolator {
  Interpolator({roads, depots})
      : super(roads: roads, depots: depots, getData: getPositionData);
}

@visibleForTesting
class TestInterpolator extends _Interpolator {
  TestInterpolator({roads, depots, getData})
      : super(roads: roads, depots: depots, getData: getData);
}
