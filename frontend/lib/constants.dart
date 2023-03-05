import 'package:flutter/material.dart';
import 'package:frontend/state/render_road.dart';
import 'package:frontend/state/render_simulation.dart';
import 'package:frontend/state/render_vehicle.dart';

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
Color opaqueUIColour = const Color(0xff37422F);
Color transparentUiColour = const Color(0xB0000000);
Color shadowColour = const Color(0x44000000);

const double roadWidth = 20;
const Size carSize = Size(8, 15);

const double maxZoomIn = 10;
const double maxZoomOut = 0.1;

const double translateDragCoefficient = 0.00001;

const double vehicleSelectionRadius = 20;

const RenderSimulationState exampleState = RenderSimulationState(
  depots: [],
  vehicles: v,
  roads: [
    RenderStraightRoad(
        id: RenderRoadID(1), start: Offset(-150, -150), end: Offset(150, 150)),
    RenderStraightRoad(
        id: RenderRoadID(2), start: Offset(150, -150), end: Offset(-150, 150)),
    RenderArcRoad(
      id: RenderRoadID(3),
      centre: Offset(0, 0),
      radius: 150,
      arcStart: 0.25 * 3.14 * 2,
      arcEnd: 1 * 3.14 * 2,
      clockwise: true,
    ),
    RenderArcRoad(
      id: RenderRoadID(4),
      centre: Offset(0, 0),
      radius: 250,
      arcStart: 0.75 * 3.14 * 2,
      arcEnd: 0 * 3.14 * 2,
      clockwise: true,
    ),
  ],
);


const v = [
  RenderVehicle(id: RenderVehicleID(0), position: Offset(102, 62), direction: 5.608969744686617),
  RenderVehicle(id: RenderVehicleID(1), position: Offset(40, 110), direction: 1.7445214393346937),
  RenderVehicle(id: RenderVehicleID(2), position: Offset(-10, -9), direction: 5.6567867783187555),
  RenderVehicle(id: RenderVehicleID(3), position: Offset(113, 55), direction: 0.5471763139782764),
  RenderVehicle(id: RenderVehicleID(4), position: Offset(49, 104), direction: 2.8240425467591033),
  RenderVehicle(id: RenderVehicleID(5), position: Offset(-52, 124), direction: 2.1959639888658202),
  RenderVehicle(id: RenderVehicleID(6), position: Offset(-69, -37), direction: 1.2889126063588996),
  RenderVehicle(id: RenderVehicleID(7), position: Offset(-150, 139), direction: 1.1425321291179376),
  RenderVehicle(id: RenderVehicleID(8), position: Offset(-130, -67), direction: 4.287204565600581),
  RenderVehicle(id: RenderVehicleID(9), position: Offset(95, -2), direction: 3.1063090103298383),
  RenderVehicle(id: RenderVehicleID(10), position: Offset(75, -140), direction: 1.5047759636368006),
  RenderVehicle(id: RenderVehicleID(11), position: Offset(6, 77), direction: 1.9337191606014013),
  RenderVehicle(id: RenderVehicleID(12), position: Offset(107, -47), direction: 3.1301328753306534),
  RenderVehicle(id: RenderVehicleID(13), position: Offset(-12, -99), direction: 4.500264090125347),
  RenderVehicle(id: RenderVehicleID(14), position: Offset(-25, 51), direction: 2.8142844701489294),
  RenderVehicle(id: RenderVehicleID(15), position: Offset(-139, -116), direction: 5.085138291128838),
  RenderVehicle(id: RenderVehicleID(16), position: Offset(13, 21), direction: 0.011149042590291163),
  RenderVehicle(id: RenderVehicleID(17), position: Offset(-129, -112), direction: 3.916292115936303),
  RenderVehicle(id: RenderVehicleID(18), position: Offset(-3, 140), direction: 0.7003286990935511),
  RenderVehicle(id: RenderVehicleID(19), position: Offset(94, -109), direction: 4.4947272106658165),
  RenderVehicle(id: RenderVehicleID(20), position: Offset(112, -27), direction: 3.1645293965601753),
  RenderVehicle(id: RenderVehicleID(21), position: Offset(-9, 14), direction: 1.9682205926699061),
  RenderVehicle(id: RenderVehicleID(22), position: Offset(-19, -39), direction: 4.78597581934579),
  RenderVehicle(id: RenderVehicleID(23), position: Offset(85, -19), direction: 0.9390827122040643),
  RenderVehicle(id: RenderVehicleID(24), position: Offset(20, -15), direction: 2.8461767940124116),
  RenderVehicle(id: RenderVehicleID(25), position: Offset(-11, 113), direction: 1.2523889173031761),
  RenderVehicle(id: RenderVehicleID(26), position: Offset(106, -2), direction: 0.009470856137475777),
  RenderVehicle(id: RenderVehicleID(27), position: Offset(-127, 28), direction: 3.7485540564531212),
  RenderVehicle(id: RenderVehicleID(28), position: Offset(-76, -126), direction: 0.1462974439297514),
  RenderVehicle(id: RenderVehicleID(29), position: Offset(-104, -34), direction: 2.8786409908009514),
  RenderVehicle(id: RenderVehicleID(30), position: Offset(91, -102), direction: 5.405028260478375),
  RenderVehicle(id: RenderVehicleID(31), position: Offset(132, 131), direction: 2.0592985127387227),
  RenderVehicle(id: RenderVehicleID(32), position: Offset(-13, 150), direction: 0.6581140507275618),
  RenderVehicle(id: RenderVehicleID(33), position: Offset(-80, -31), direction: 2.2636211319411155),
  RenderVehicle(id: RenderVehicleID(34), position: Offset(125, -130), direction: 1.048946954252779),
  RenderVehicle(id: RenderVehicleID(35), position: Offset(42, -129), direction: 4.758080795765871),
  RenderVehicle(id: RenderVehicleID(36), position: Offset(119, 150), direction: 1.297815956373598),
  RenderVehicle(id: RenderVehicleID(37), position: Offset(-80, 51), direction: 2.0513729508270364),
  RenderVehicle(id: RenderVehicleID(38), position: Offset(-129, -6), direction: 1.6933750416823978),
  RenderVehicle(id: RenderVehicleID(39), position: Offset(78, -28), direction: 5.263318662416948),
  RenderVehicle(id: RenderVehicleID(40), position: Offset(120, -29), direction: 2.998753867614513),
  RenderVehicle(id: RenderVehicleID(41), position: Offset(-69, 16), direction: 1.5744925493912298),
  RenderVehicle(id: RenderVehicleID(42), position: Offset(44, 109), direction: 3.6647183050580976),
  RenderVehicle(id: RenderVehicleID(43), position: Offset(-137, 51), direction: 4.017055097362296),
  RenderVehicle(id: RenderVehicleID(44), position: Offset(-34, -129), direction: 4.314750032791288),
  RenderVehicle(id: RenderVehicleID(45), position: Offset(17, -63), direction: 1.4367735768313725),
  RenderVehicle(id: RenderVehicleID(46), position: Offset(1, 1), direction: 4.187449569496504),
  RenderVehicle(id: RenderVehicleID(47), position: Offset(-24, 112), direction: 5.2826806678869245),
  RenderVehicle(id: RenderVehicleID(48), position: Offset(58, -46), direction: 5.990596988797138),
  RenderVehicle(id: RenderVehicleID(49), position: Offset(-29, -103), direction: 0.4768720300971163),
  RenderVehicle(id: RenderVehicleID(50), position: Offset(60, -31), direction: 1.322537066667396),
  RenderVehicle(id: RenderVehicleID(51), position: Offset(109, 133), direction: 5.35141744786337),
  RenderVehicle(id: RenderVehicleID(52), position: Offset(136, -144), direction: 0.44523837073287),
  RenderVehicle(id: RenderVehicleID(53), position: Offset(-45, 18), direction: 1.4440521612848332),
  RenderVehicle(id: RenderVehicleID(54), position: Offset(-124, 126), direction: 2.9360740682024935),
  RenderVehicle(id: RenderVehicleID(55), position: Offset(126, -33), direction: 1.5242802271310072),
  RenderVehicle(id: RenderVehicleID(56), position: Offset(-126, 69), direction: 0.738623174734043),
  RenderVehicle(id: RenderVehicleID(57), position: Offset(-142, -98), direction: 5.177915061828122),
  RenderVehicle(id: RenderVehicleID(58), position: Offset(-144, -142), direction: 0.3075495582876795),
  RenderVehicle(id: RenderVehicleID(59), position: Offset(-26, -6), direction: 1.534916653974425),
  RenderVehicle(id: RenderVehicleID(60), position: Offset(87, 149), direction: 3.5042052347091563),
  RenderVehicle(id: RenderVehicleID(61), position: Offset(-49, -36), direction: 0.6467993349965272),
  RenderVehicle(id: RenderVehicleID(62), position: Offset(33, -117), direction: 0.8631001761350815),
  RenderVehicle(id: RenderVehicleID(63), position: Offset(5, 84), direction: 4.330492680161893),
  RenderVehicle(id: RenderVehicleID(64), position: Offset(-72, -146), direction: 2.20767904242242),
  RenderVehicle(id: RenderVehicleID(65), position: Offset(143, 4), direction: 0.4079430306144225),
  RenderVehicle(id: RenderVehicleID(66), position: Offset(53, -59), direction: 6.135432499738451),
  RenderVehicle(id: RenderVehicleID(67), position: Offset(-59, -67), direction: 1.73540374200844),
  RenderVehicle(id: RenderVehicleID(68), position: Offset(-92, 18), direction: 2.125009844481797),
  RenderVehicle(id: RenderVehicleID(69), position: Offset(-93, -1), direction: 3.454403949580124),
  RenderVehicle(id: RenderVehicleID(70), position: Offset(-37, 80), direction: 0.5826674080843852),
  RenderVehicle(id: RenderVehicleID(71), position: Offset(-145, 87), direction: 0.14607238828117455),
  RenderVehicle(id: RenderVehicleID(72), position: Offset(-75, -65), direction: 1.255763561478409),
  RenderVehicle(id: RenderVehicleID(73), position: Offset(66, -110), direction: 0.6542865693827176),
  RenderVehicle(id: RenderVehicleID(74), position: Offset(-29, -20), direction: 3.1299160340838283),
  RenderVehicle(id: RenderVehicleID(75), position: Offset(87, 14), direction: 5.940727834486349),
  RenderVehicle(id: RenderVehicleID(76), position: Offset(-66, 9), direction: 4.328334792642933),
  RenderVehicle(id: RenderVehicleID(77), position: Offset(144, 146), direction: 5.180441133815522),
  RenderVehicle(id: RenderVehicleID(78), position: Offset(-85, 17), direction: 5.156446884013017),
  RenderVehicle(id: RenderVehicleID(79), position: Offset(-100, 79), direction: 3.7668463754384067),
  RenderVehicle(id: RenderVehicleID(80), position: Offset(42, 139), direction: 5.083759756496092),
  RenderVehicle(id: RenderVehicleID(81), position: Offset(24, 139), direction: 6.207380140906384),
  RenderVehicle(id: RenderVehicleID(82), position: Offset(-21, 37), direction: 4.009111170640616),
  RenderVehicle(id: RenderVehicleID(83), position: Offset(14, -2), direction: 4.910990254996219),
  RenderVehicle(id: RenderVehicleID(84), position: Offset(39, -130), direction: 4.722652643331924),
  RenderVehicle(id: RenderVehicleID(85), position: Offset(129, -49), direction: 3.512049646545379),
  RenderVehicle(id: RenderVehicleID(86), position: Offset(-12, -48), direction: 3.6324783693149363),
  RenderVehicle(id: RenderVehicleID(87), position: Offset(-29, -108), direction: 3.988880126896782),
  RenderVehicle(id: RenderVehicleID(88), position: Offset(32, -150), direction: 1.8715575474757353),
  RenderVehicle(id: RenderVehicleID(89), position: Offset(-84, 129), direction: 2.9904630945738053),
  RenderVehicle(id: RenderVehicleID(90), position: Offset(45, -53), direction: 3.658917079529123),
  RenderVehicle(id: RenderVehicleID(91), position: Offset(-137, 92), direction: 2.51302456854904),
  RenderVehicle(id: RenderVehicleID(92), position: Offset(-121, -148), direction: 5.501589175762651),
  RenderVehicle(id: RenderVehicleID(93), position: Offset(107, -103), direction: 2.00297169215094),
  RenderVehicle(id: RenderVehicleID(94), position: Offset(-76, -126), direction: 0.5268382809436711),
  RenderVehicle(id: RenderVehicleID(95), position: Offset(-113, 67), direction: 4.507625621812082),
  RenderVehicle(id: RenderVehicleID(96), position: Offset(-13, 132), direction: 5.335521707705858),
  RenderVehicle(id: RenderVehicleID(97), position: Offset(60, -119), direction: 5.560583275677487),
  RenderVehicle(id: RenderVehicleID(98), position: Offset(15, 37), direction: 5.16410189891083),
  RenderVehicle(id: RenderVehicleID(99), position: Offset(-44, -97), direction: 0.048838461430592735),
];