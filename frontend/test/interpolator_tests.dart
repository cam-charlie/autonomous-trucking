import 'dart:ui';
import 'package:frontend/state/rendering/interpolator.dart';
import 'package:frontend/state/rendering/road.dart';
import 'package:frontend/state/rendering/faketrucking.dart';
import 'dart:math';

import 'package:frontend/state/rendering/simulation.dart';
import 'package:flutter_test/flutter_test.dart';

List<RenderRoad> roads = [
  const StraightRenderRoad(id: RID(1), start: Offset(0, 0), end: Offset(0, 1)),
  const StraightRenderRoad(id: RID(2), start: Offset(0, 1), end: Offset(0, 2)),
  const StraightRenderRoad(id: RID(3), start: Offset(0, 2), end: Offset(2, 2)),
  const RenderArcRoad(
      id: RID(4),
      centre: Offset(2, 1),
      radius: 1,
      arcStart: 0,
      arcEnd: pi,
      clockwise: true)
];
List<TruckPositionsAtTime> testData = [
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 1,
        progress: 0)
  ], time: 0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 1,
        progress: 0.5)
  ], time: 0.5)
];

Future<List<TruckPositionsAtTime>> testFunc(double t) async {
  if (0 < t && t < 0.5) {
    return [testData[0], testData[1]];
  } else if (t == 0) {
    return [testData[0]];
  } else {
    return [testData[1]];
  }
}

void main() async {
  Interpolator inter = Interpolator(roads: roads, getData: testFunc);

  print("Beginning tests");

  // t0 -> First frame
  // ti -> Interpolated frame
  // t1 -> Final frame

  test("Test that frames match when t0 = ti", () async {
    SimulationState temp = await inter.getState(0.0);
    expect((temp.vehicles[0].position - const Offset(0, 0)).distance < 0.001,
        true);
    expect(temp.roads, roads);
  });

  test("Vehicle moves linearly between two points", () async {
    SimulationState ti0 = await inter.getState(0.0);
    SimulationState ti1 = await inter.getState(0.1);
    SimulationState ti2 = await inter.getState(0.2);
    SimulationState ti3 = await inter.getState(0.3);
    SimulationState ti4 = await inter.getState(0.4);
    SimulationState ti5 = await inter.getState(0.5);
    print(ti1.vehicles[0].position.dy);
    print(ti2.vehicles[0].position.dy);
    expect((ti0.vehicles[0].position - const Offset(0, 0.0)).distance < 0.001,
        true);
    expect((ti1.vehicles[0].position - const Offset(0, 0.1)).distance < 0.001,
        true);
    expect((ti2.vehicles[0].position - const Offset(0, 0.2)).distance < 0.001,
        true);
    expect((ti3.vehicles[0].position - const Offset(0, 0.3)).distance < 0.001,
        true);
    expect((ti4.vehicles[0].position - const Offset(0, 0.4)).distance < 0.001,
        true);
    expect((ti5.vehicles[0].position - const Offset(0, 0.5)).distance < 0.001,
        true);
  });
}
