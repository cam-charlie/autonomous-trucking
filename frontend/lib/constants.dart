import 'package:flutter/material.dart';
import 'package:frontend/state/road.dart';
import 'package:frontend/state/simulation.dart';
import 'package:frontend/state/vehicle.dart';

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

const SimulationState exampleState = SimulationState(
  vehicles: v,
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


const v = [
Vehicle(id: VID(0), position: Offset(102, 62), direction: 5.608969744686617),
Vehicle(id: VID(1), position: Offset(40, 110), direction: 1.7445214393346937),
Vehicle(id: VID(2), position: Offset(-10, -9), direction: 5.6567867783187555),
Vehicle(id: VID(3), position: Offset(113, 55), direction: 0.5471763139782764),
Vehicle(id: VID(4), position: Offset(49, 104), direction: 2.8240425467591033),
Vehicle(id: VID(5), position: Offset(-52, 124), direction: 2.1959639888658202),
Vehicle(id: VID(6), position: Offset(-69, -37), direction: 1.2889126063588996),
Vehicle(id: VID(7), position: Offset(-150, 139), direction: 1.1425321291179376),
Vehicle(id: VID(8), position: Offset(-130, -67), direction: 4.287204565600581),
Vehicle(id: VID(9), position: Offset(95, -2), direction: 3.1063090103298383),
Vehicle(id: VID(10), position: Offset(75, -140), direction: 1.5047759636368006),
Vehicle(id: VID(11), position: Offset(6, 77), direction: 1.9337191606014013),
Vehicle(id: VID(12), position: Offset(107, -47), direction: 3.1301328753306534),
Vehicle(id: VID(13), position: Offset(-12, -99), direction: 4.500264090125347),
Vehicle(id: VID(14), position: Offset(-25, 51), direction: 2.8142844701489294),
Vehicle(id: VID(15), position: Offset(-139, -116), direction: 5.085138291128838),
Vehicle(id: VID(16), position: Offset(13, 21), direction: 0.011149042590291163),
Vehicle(id: VID(17), position: Offset(-129, -112), direction: 3.916292115936303),
Vehicle(id: VID(18), position: Offset(-3, 140), direction: 0.7003286990935511),
Vehicle(id: VID(19), position: Offset(94, -109), direction: 4.4947272106658165),
Vehicle(id: VID(20), position: Offset(112, -27), direction: 3.1645293965601753),
Vehicle(id: VID(21), position: Offset(-9, 14), direction: 1.9682205926699061),
Vehicle(id: VID(22), position: Offset(-19, -39), direction: 4.78597581934579),
Vehicle(id: VID(23), position: Offset(85, -19), direction: 0.9390827122040643),
Vehicle(id: VID(24), position: Offset(20, -15), direction: 2.8461767940124116),
Vehicle(id: VID(25), position: Offset(-11, 113), direction: 1.2523889173031761),
Vehicle(id: VID(26), position: Offset(106, -2), direction: 0.009470856137475777),
Vehicle(id: VID(27), position: Offset(-127, 28), direction: 3.7485540564531212),
Vehicle(id: VID(28), position: Offset(-76, -126), direction: 0.1462974439297514),
Vehicle(id: VID(29), position: Offset(-104, -34), direction: 2.8786409908009514),
Vehicle(id: VID(30), position: Offset(91, -102), direction: 5.405028260478375),
Vehicle(id: VID(31), position: Offset(132, 131), direction: 2.0592985127387227),
Vehicle(id: VID(32), position: Offset(-13, 150), direction: 0.6581140507275618),
Vehicle(id: VID(33), position: Offset(-80, -31), direction: 2.2636211319411155),
Vehicle(id: VID(34), position: Offset(125, -130), direction: 1.048946954252779),
Vehicle(id: VID(35), position: Offset(42, -129), direction: 4.758080795765871),
Vehicle(id: VID(36), position: Offset(119, 150), direction: 1.297815956373598),
Vehicle(id: VID(37), position: Offset(-80, 51), direction: 2.0513729508270364),
Vehicle(id: VID(38), position: Offset(-129, -6), direction: 1.6933750416823978),
Vehicle(id: VID(39), position: Offset(78, -28), direction: 5.263318662416948),
Vehicle(id: VID(40), position: Offset(120, -29), direction: 2.998753867614513),
Vehicle(id: VID(41), position: Offset(-69, 16), direction: 1.5744925493912298),
Vehicle(id: VID(42), position: Offset(44, 109), direction: 3.6647183050580976),
Vehicle(id: VID(43), position: Offset(-137, 51), direction: 4.017055097362296),
Vehicle(id: VID(44), position: Offset(-34, -129), direction: 4.314750032791288),
Vehicle(id: VID(45), position: Offset(17, -63), direction: 1.4367735768313725),
Vehicle(id: VID(46), position: Offset(1, 1), direction: 4.187449569496504),
Vehicle(id: VID(47), position: Offset(-24, 112), direction: 5.2826806678869245),
Vehicle(id: VID(48), position: Offset(58, -46), direction: 5.990596988797138),
Vehicle(id: VID(49), position: Offset(-29, -103), direction: 0.4768720300971163),
Vehicle(id: VID(50), position: Offset(60, -31), direction: 1.322537066667396),
Vehicle(id: VID(51), position: Offset(109, 133), direction: 5.35141744786337),
Vehicle(id: VID(52), position: Offset(136, -144), direction: 0.44523837073287),
Vehicle(id: VID(53), position: Offset(-45, 18), direction: 1.4440521612848332),
Vehicle(id: VID(54), position: Offset(-124, 126), direction: 2.9360740682024935),
Vehicle(id: VID(55), position: Offset(126, -33), direction: 1.5242802271310072),
Vehicle(id: VID(56), position: Offset(-126, 69), direction: 0.738623174734043),
Vehicle(id: VID(57), position: Offset(-142, -98), direction: 5.177915061828122),
Vehicle(id: VID(58), position: Offset(-144, -142), direction: 0.3075495582876795),
Vehicle(id: VID(59), position: Offset(-26, -6), direction: 1.534916653974425),
Vehicle(id: VID(60), position: Offset(87, 149), direction: 3.5042052347091563),
Vehicle(id: VID(61), position: Offset(-49, -36), direction: 0.6467993349965272),
Vehicle(id: VID(62), position: Offset(33, -117), direction: 0.8631001761350815),
Vehicle(id: VID(63), position: Offset(5, 84), direction: 4.330492680161893),
Vehicle(id: VID(64), position: Offset(-72, -146), direction: 2.20767904242242),
Vehicle(id: VID(65), position: Offset(143, 4), direction: 0.4079430306144225),
Vehicle(id: VID(66), position: Offset(53, -59), direction: 6.135432499738451),
Vehicle(id: VID(67), position: Offset(-59, -67), direction: 1.73540374200844),
Vehicle(id: VID(68), position: Offset(-92, 18), direction: 2.125009844481797),
Vehicle(id: VID(69), position: Offset(-93, -1), direction: 3.454403949580124),
Vehicle(id: VID(70), position: Offset(-37, 80), direction: 0.5826674080843852),
Vehicle(id: VID(71), position: Offset(-145, 87), direction: 0.14607238828117455),
Vehicle(id: VID(72), position: Offset(-75, -65), direction: 1.255763561478409),
Vehicle(id: VID(73), position: Offset(66, -110), direction: 0.6542865693827176),
Vehicle(id: VID(74), position: Offset(-29, -20), direction: 3.1299160340838283),
Vehicle(id: VID(75), position: Offset(87, 14), direction: 5.940727834486349),
Vehicle(id: VID(76), position: Offset(-66, 9), direction: 4.328334792642933),
Vehicle(id: VID(77), position: Offset(144, 146), direction: 5.180441133815522),
Vehicle(id: VID(78), position: Offset(-85, 17), direction: 5.156446884013017),
Vehicle(id: VID(79), position: Offset(-100, 79), direction: 3.7668463754384067),
Vehicle(id: VID(80), position: Offset(42, 139), direction: 5.083759756496092),
Vehicle(id: VID(81), position: Offset(24, 139), direction: 6.207380140906384),
Vehicle(id: VID(82), position: Offset(-21, 37), direction: 4.009111170640616),
Vehicle(id: VID(83), position: Offset(14, -2), direction: 4.910990254996219),
Vehicle(id: VID(84), position: Offset(39, -130), direction: 4.722652643331924),
Vehicle(id: VID(85), position: Offset(129, -49), direction: 3.512049646545379),
Vehicle(id: VID(86), position: Offset(-12, -48), direction: 3.6324783693149363),
Vehicle(id: VID(87), position: Offset(-29, -108), direction: 3.988880126896782),
Vehicle(id: VID(88), position: Offset(32, -150), direction: 1.8715575474757353),
Vehicle(id: VID(89), position: Offset(-84, 129), direction: 2.9904630945738053),
Vehicle(id: VID(90), position: Offset(45, -53), direction: 3.658917079529123),
Vehicle(id: VID(91), position: Offset(-137, 92), direction: 2.51302456854904),
Vehicle(id: VID(92), position: Offset(-121, -148), direction: 5.501589175762651),
Vehicle(id: VID(93), position: Offset(107, -103), direction: 2.00297169215094),
Vehicle(id: VID(94), position: Offset(-76, -126), direction: 0.5268382809436711),
Vehicle(id: VID(95), position: Offset(-113, 67), direction: 4.507625621812082),
Vehicle(id: VID(96), position: Offset(-13, 132), direction: 5.335521707705858),
Vehicle(id: VID(97), position: Offset(60, -119), direction: 5.560583275677487),
Vehicle(id: VID(98), position: Offset(15, 37), direction: 5.16410189891083),
Vehicle(id: VID(99), position: Offset(-44, -97), direction: 0.048838461430592735),
];