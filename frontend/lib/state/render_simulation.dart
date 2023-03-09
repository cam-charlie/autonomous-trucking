import 'package:collection/collection.dart';
import 'package:frontend/state/render_depot.dart';
import 'package:frontend/state/render_outline.dart';
import 'package:frontend/state/render_road.dart';
import 'package:frontend/state/render_text.dart';

import 'render_vehicle.dart';

class RenderSimulationState {
  final List<RenderVehicle> vehicles;
  final List<RenderRoad> roads;
  final List<RenderDepot> depots;
  final List<RenderOutline> outlines;
  final List<RenderText> text;

  const RenderSimulationState({
    required this.vehicles,
    required this.roads,
    required this.depots,
    required this.outlines,
    required this.text,
  });

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(vehicles), Object.hashAll(roads));

  @override
  bool operator ==(Object other) {
    return (other is RenderSimulationState) &&
        const ListEquality().equals(vehicles, other.vehicles) &&
        const ListEquality().equals(roads, other.roads) &&
        const ListEquality().equals(depots, other.depots);
  }
}
