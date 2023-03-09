import 'dart:math';

import 'package:frontend/generation/store_state.dart';
import 'package:frontend/state/render_depot.dart';

import '../state/render_outline.dart';
import '../state/render_road.dart';
import '../state/render_text.dart';

class StaticRenderData {
  final List<RenderRoad> roads;
  final List<RenderDepot> depots;
  final List<RenderOutline> outlines;
  final List<RenderText> text;

  const StaticRenderData(this.roads, this.depots, this.outlines, this.text);
}

StaticRenderData convertStoreStateToRenderData(StoreSimulationState state) {
  return StaticRenderData(
    convertStoreStateToRenderRoads(state),
    convertStoreStateToRenderDepots(state),
    convertStoreStateToRenderOutlines(state),
    convertStoreStateToRenderTexts(state),
  );
}

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

List<RenderOutline> convertStoreStateToRenderOutlines(
    StoreSimulationState state) {
  return state.outlines.map((points) => RenderOutline(points)).toList();
}

List<RenderText> convertStoreStateToRenderTexts(StoreSimulationState state) {
  return state.text
      .map((StoreText t) => RenderText(t.text, t.position))
      .toList();
}
