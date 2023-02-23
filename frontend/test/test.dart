import 'dart:ui';

import 'package:frontend/state/rendering/interpolator.dart';
import 'package:frontend/state/rendering/road.dart';
import 'package:frontend/state/communication/Backend.dart';

void main() async {
  List<RenderRoad> roads = [
    const StraightRenderRoad(
        id: RID(1), start: Offset(0, 0), end: Offset(0, 200))
  ];
  await startFromConfig(1);

  Interpolator inter = Interpolator(roads: roads);

  for (double i = 0; i < 300000; i += 0.01) {
    print((await inter.getState(i)).vehicles[0]);
  }
}
