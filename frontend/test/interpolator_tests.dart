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
  ], time: 0.5),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 0,
        currAccel: 2,
        roadId: 1,
        progress: 0)
  ], time: 1.0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 2,
        roadId: 1,
        progress: 0.25)
  ], time: 1.5),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 0,
        currAccel: 0,
        roadId: 1,
        progress: 0)
  ], time: 2.0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 0.75,
        currAccel: 3,
        roadId: 1,
        progress: 0.125)
  ], time: 2.5),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 1,
        progress: 0.75)
  ], time: 3.0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 2,
        progress: 0.25)
  ], time: 3.5),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 2,
        progress: 0.75)
  ], time: 4.0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 1,
        currAccel: 0,
        roadId: 3,
        progress: 0.125)
  ], time: 4.5),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 2 * pi,
        currAccel: 0,
        roadId: 4,
        progress: 0.0)
  ], time: 5.0),
  TruckPositionsAtTime(trucks: [
    Truck(
        truckId: 1,
        destinationId: 0,
        currSpeed: 2 * pi,
        currAccel: 0,
        roadId: 4,
        progress: 0.99)
  ], time: 5.5),
];

Future<List<TruckPositionsAtTime>> testFunc(double t) async {
  if (0 <= t && t <= 0.5) {
    return [testData[0], testData[1]];
  } else if (t < 2) {
    return [testData[2], testData[3]];
  } else if (t < 3) {
    return [testData[4], testData[5]];
  } else if (t < 4) {
    return [testData[6], testData[7]];
  } else if (t < 5) {
    return [testData[8], testData[9]];
  } else {
    return [testData[10], testData[11]];
  }
}

void main() async {
  TestInterpolator inter = TestInterpolator(roads: roads, getData: testFunc);

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

  // Tests regarding movement calculation
  // s = s0 + v0(t) + (1/2)a0(t^2) + (1/6)j(t^3)
  test("Vehicle constant speed between two points", () async {
    SimulationState ti0 = await inter.getState(0.0);
    SimulationState ti1 = await inter.getState(0.1);
    SimulationState ti2 = await inter.getState(0.2);
    SimulationState ti3 = await inter.getState(0.3);
    SimulationState ti4 = await inter.getState(0.4);
    SimulationState ti5 = await inter.getState(0.5);
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

  test("Vehicle linear speed between two points", () async {
    SimulationState ti0 = await inter.getState(1.0);
    SimulationState ti1 = await inter.getState(1.1);
    SimulationState ti2 = await inter.getState(1.2);
    SimulationState ti3 = await inter.getState(1.3);
    SimulationState ti4 = await inter.getState(1.4);
    SimulationState ti5 = await inter.getState(1.5);
    expect((ti0.vehicles[0].position - const Offset(0, 0.0)).distance < 0.001,
        true);
    expect((ti1.vehicles[0].position - const Offset(0, 0.01)).distance < 0.001,
        true);
    expect((ti2.vehicles[0].position - const Offset(0, 0.04)).distance < 0.001,
        true);
    expect((ti3.vehicles[0].position - const Offset(0, 0.09)).distance < 0.001,
        true);
    expect((ti4.vehicles[0].position - const Offset(0, 0.16)).distance < 0.001,
        true);
    expect((ti5.vehicles[0].position - const Offset(0, 0.25)).distance < 0.001,
        true);
  });

  test("Vehicle quadratic speed between two points", () async {
    SimulationState ti0 = await inter.getState(2.0);
    SimulationState ti1 = await inter.getState(2.1);
    SimulationState ti2 = await inter.getState(2.2);
    SimulationState ti3 = await inter.getState(2.3);
    SimulationState ti4 = await inter.getState(2.4);
    SimulationState ti5 = await inter.getState(2.5);
    expect((ti0.vehicles[0].position - const Offset(0, 0.0)).distance < 0.001,
        true);
    expect((ti1.vehicles[0].position - const Offset(0, 0.001)).distance < 0.001,
        true);
    expect((ti2.vehicles[0].position - const Offset(0, 0.008)).distance < 0.001,
        true);
    expect((ti3.vehicles[0].position - const Offset(0, 0.027)).distance < 0.001,
        true);
    expect((ti4.vehicles[0].position - const Offset(0, 0.064)).distance < 0.001,
        true);
    expect((ti5.vehicles[0].position - const Offset(0, 0.125)).distance < 0.001,
        true);
  });

  // Tests regarding road interaction
  test("Vehicle road change with similar roads", () async {
    SimulationState ti0 = await inter.getState(3.0);
    SimulationState ti1 = await inter.getState(3.1);
    SimulationState ti2 = await inter.getState(3.2);
    SimulationState ti3 = await inter.getState(3.3);
    SimulationState ti4 = await inter.getState(3.4);
    SimulationState ti5 = await inter.getState(3.5);

    expect((ti0.vehicles[0].position - const Offset(0, 0.75)).distance < 0.01,
        true);
    expect((ti1.vehicles[0].position - const Offset(0, 0.85)).distance < 0.01,
        true);
    expect((ti2.vehicles[0].position - const Offset(0, 0.95)).distance < 0.01,
        true);
    expect((ti3.vehicles[0].position - const Offset(0, 1.05)).distance < 0.01,
        true);
    expect((ti4.vehicles[0].position - const Offset(0, 1.15)).distance < 0.01,
        true);
    expect((ti5.vehicles[0].position - const Offset(0, 1.25)).distance < 0.01,
        true);

    expect(ti2.vehicles[0].direction, 0);
    expect(ti3.vehicles[0].direction, 0);
  });

  test("Vehicle road change with roads of different length and orientation",
      () async {
    SimulationState ti0 = await inter.getState(4.0);
    SimulationState ti1 = await inter.getState(4.1);
    SimulationState ti2 = await inter.getState(4.2);
    SimulationState ti3 = await inter.getState(4.3);
    SimulationState ti4 = await inter.getState(4.4);
    SimulationState ti5 = await inter.getState(4.5);

    expect((ti0.vehicles[0].position - const Offset(0, 1.75)).distance < 0.01,
        true);

    expect((ti1.vehicles[0].position - const Offset(0, 1.85)).distance < 0.01,
        true);

    expect((ti2.vehicles[0].position - const Offset(0, 1.95)).distance < 0.01,
        true);

    expect((ti3.vehicles[0].position - const Offset(0.05, 2)).distance < 0.01,
        true);

    expect((ti4.vehicles[0].position - const Offset(0.15, 2)).distance < 0.01,
        true);

    expect((ti5.vehicles[0].position - const Offset(0.25, 2)).distance < 0.01,
        true);

    expect(ti2.vehicles[0].direction, 0);
    expect(ti3.vehicles[0].direction, pi / 2);
  });

  test("Vehicle positions along a curved road", () async {
    SimulationState ti0 = await inter.getState(5.0);
    print(ti0.vehicles[0].position);
    SimulationState ti1 = await inter.getState(5.25);
    print(ti1.vehicles[0].position);
    SimulationState ti2 = await inter.getState(5.5);
    print(ti2.vehicles[0].position);

    expect(
        (ti0.vehicles[0].position - const Offset(2, 2)).distance < 0.01, true);
    expect(
        (ti1.vehicles[0].position - const Offset(3, 1)).distance < 0.01, true);
    expect(
        (ti2.vehicles[0].position - const Offset(2, 0)).distance < 0.01, true);

    expect(ti0.vehicles[0].direction, pi / 2);
    expect(ti1.vehicles[0].direction, pi);
    expect(ti2.vehicles[0].direction, 3 * pi / 2);
  });
}
