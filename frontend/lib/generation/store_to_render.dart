import 'dart:math';

import 'package:frontend/generation/store_state.dart';
import 'package:frontend/state/render_depot.dart';
import '../state/render_road.dart';

List<RenderRoad> convertStoreStateToRenderRoads(StoreSimulationState state) {
  return state.roadMap.values.map<RenderRoad>((StoreRoad r) {
    if (r is StoreStraightRoad) {
      return RenderStraightRoad(
        id: RenderRoadID(r.id.value),
        start: state.nodeMap[r.startNode]!.position,
        end: state.nodeMap[r.endNode]!.position,
      );
    } else if (r is StoreArcRoad) {
      return RenderArcRoad(
        id: RenderRoadID(r.id.value),
        centre: r.centre,
        radius: r.radius,
        arcStart: r.startAngle,
        arcEnd: (r.startAngle + r.sweepAngle) % (2 * pi),
        clockwise: r.sweepAngle > 0,
      );
    }
    throw Exception();
  }).toList();
}

List<RenderDepot> convertStoreStateToRenderDepots(StoreSimulationState state) {
  return state.nodeMap.values
      .where((StoreNode s) => s.type == StoreNodeType.depot)
      .map<RenderDepot>((StoreNode s) =>
          RenderDepot(id: RenderDepotID(s.id.value), position: s.position))
      .toList();
}
