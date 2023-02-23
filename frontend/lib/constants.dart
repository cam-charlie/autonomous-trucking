import 'package:flutter/material.dart';
import 'package:frontend/state/rendering/road.dart';
import 'package:frontend/state/rendering/simulation.dart';
import 'package:frontend/state/rendering/vehicle.dart';

const vehicleColours = <MaterialColor>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  // Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  // Colors.teal,
  // Colors.green,
  // Colors.lightGreen,
  // Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  // Colors.brown,
  Colors.blueGrey,
];

Color backgroundColour = const Color(0xffB2D497);
Color roadColour = const Color(0xff5B5B5B);
Color uiColour = const Color(0xB0000000);
Color shadowColour = const Color(0x44000000);

const double roadWidth = 20;
const Size carSize = Size(8, 15);

const double maxZoomIn = 10;
const double maxZoomOut = 0.1;

const double translateDragCoefficient = 0.00001;

const SimulationState exampleState = SimulationState(
  vehicles: [
    Vehicle(id: VID(0), position: Offset(10, 20), direction: 0.25 * 3.14)
  ],
  roads: [
    StraightRenderRoad(
        id: RID(1), start: Offset(-150, -150), end: Offset(150, 150)),
    StraightRenderRoad(
        id: RID(2), start: Offset(150, -150), end: Offset(-150, 150)),
    RenderArcRoad(
      id: RID(3),
      centre: Offset(0, 0),
      radius: 150,
      arcStart: 0.25 * 3.14 * 2,
      arcEnd: 1 * 3.14 * 2,
      clockwise: true,
    ),
    RenderArcRoad(
      id: RID(4),
      centre: Offset(0, 0),
      radius: 250,
      arcStart: 0.75 * 3.14 * 2,
      arcEnd: 0 * 3.14 * 2,
      clockwise: true,
    ),
  ],
);
