import 'dart:math';
import 'dart:ui';

import 'package:frontend/state/render_road.dart';

double length(RenderRoad road) {
  if (road is RenderStraightRoad) {
    return (road.start - road.end).distance;
  } else if (road is RenderArcRoad) {
    double arcDif = (road.arcEnd - road.arcStart) * (road.clockwise ? 1 : -1);
    return (arcDif % (2 * pi)) * road.radius;
  }
  throw Exception('Attempted road length calculation on non-road');
}

Offset positionAt(RenderRoad road, {double? distance, double? fraction}) {
  if ((distance == null) == (fraction == null)) {
    throw ArgumentError(
        "Exactly one of distance and fraction must be non-null");
  }
  fraction = distance != null ? distance / length(road) : fraction!;
  if (road is RenderStraightRoad) {
    return road.start + (road.end - road.start) * fraction;
  } else if (road is RenderArcRoad) {
    double arcDif = (road.arcEnd - road.arcStart) * (road.clockwise ? 1 : -1);
    double angle = road.arcStart + (arcDif * fraction);

    return Offset(road.centre.dx + sin(angle) * road.radius,
        road.centre.dy + cos(angle) * road.radius);
  }
  throw Exception('Attempted road position calculation on non-road');
}

double direction(RenderRoad road, {double? distance, double? fraction}) {
  if ((distance == null) == (fraction == null)) {
    throw ArgumentError(
        "Exactly one of distance and fraction must be non-null");
  }
  fraction = distance != null ? distance / length(road) : fraction!;
  if (road is RenderStraightRoad) {
    double rotation = (road.end - road.start).direction;

    return ((rotation + (3 * pi / 2)) - (2 * pi)).abs();
  } else if (road is RenderArcRoad) {
    Offset travel =
        road.centre - positionAt(road, distance: distance, fraction: fraction);
    double angle;

    if (travel.dy == 0) {
      angle = travel.dx > 0 ? pi / 2 : 3 * pi / 2;
    } else if (travel.dy > 0) {
      angle = travel.dx > 0
          ? atan(travel.dx / travel.dy)
          : 2 * pi - atan(travel.dx.abs() / travel.dy);
    } else {
      angle = travel.dx > 0
          ? pi / 2 + atan(travel.dy.abs() / travel.dx.abs())
          : travel.dx < 0
              ? 3 * pi / 2 - atan(travel.dy.abs() / travel.dx.abs())
              : pi;
    }

    return (angle + (road.clockwise ? -pi / 2 : pi / 2)) % (2 * pi);
  }
  throw Exception('Attempted vehicle direction calculation on non-road');
}
