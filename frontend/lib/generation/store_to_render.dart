import 'dart:math';

import 'package:frontend/generation/store_state.dart';
import '../state/render_road.dart';

List<RenderRoad> convertStoreStateToRenderRoads(StoreSimulationState state) {
  return state.roadMap.values.map<RenderRoad>((StoreRoad r) {
    if (r is StoreStraightRoad) {
      return RenderStraightRoad(
        id: RenderRoadID(r.id.value),
        start: state.nodeMap[r.startNode]!.position,
        end: state.nodeMap[r.startNode]!.position,
      );
    } else if (r is StoreArcRoad) {
      return RenderArcRoad(
        id: RenderRoadID(r.id.value),
        centre: r.centre,
        radius: r.radius,
        arcStart: r.startAngle,
        arcEnd: (r.startAngle + r.sweepAngle) % (2*pi),
        clockwise: r.sweepAngle > 0,
      );
    }
    throw Exception();
  }).toList();
}
