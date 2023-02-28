import 'dart:math';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/colour_tools.dart' as colour_tools;

/// Road ID
class RID extends Equatable {
  const RID(int id) : _id = id;
  final int _id;

  @override
  List<Object> get props => [_id];
}

enum RoadType {
  straight,
  arc,
}

// Final track of the Star Cup:
abstract class RenderRoad {
  const RenderRoad();

  RID get id;

  RoadType get type;

  void draw({required Canvas canvas});

  void drawOutline({required Canvas canvas});

  void drawBody({required Canvas canvas});
}

class StraightRenderRoad extends RenderRoad with EquatableMixin {
  final Offset start;
  final Offset end;
  @override
  final RoadType type;

  @override
  final RID id;

  const StraightRenderRoad(
      {required this.id, required this.start, required this.end})
      : type = RoadType.straight;

  @override
  void draw({required Canvas canvas}) {
    drawOutline(canvas: canvas);
    drawBody(canvas: canvas);
  }

  @override
  void drawBody({required Canvas canvas}) {
    final Paint paint = Paint()
      ..color = constants.roadColour
      ..strokeWidth = constants.roadWidth // * zoom
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, paint);
  }

  @override
  void drawOutline({required Canvas canvas}) {
    final Paint paint = Paint()
      ..color = colour_tools.darken(constants.roadColour)
      ..strokeWidth = constants.roadWidth + 8 // * zoom
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, paint);
  }

  @override
  List<Object> get props => [start, end, id];
}

class RenderArcRoad extends RenderRoad with EquatableMixin {
  final Offset centre;
  final double radius;
  final bool clockwise;

  /// Radians from north this road arc starts
  final double arcStart;

  /// Radians from north this road arc ends
  final double arcEnd;

  @override
  final RID id;

  @override
  final RoadType type;

  const RenderArcRoad(
      {required this.id,
      required this.centre,
      required this.radius,
      required double arcStart,
      required arcEnd,
      required this.clockwise})
      : arcStart = arcStart % (2 * pi),
        arcEnd = arcEnd % (2 * pi),
        type = RoadType.arc;

  @override
  void draw({required Canvas canvas}) {
    drawOutline(canvas: canvas);
    drawBody(canvas: canvas);
  }

  @override
  void drawOutline({required Canvas canvas}) {
    final Paint paint = Paint()
      ..color = colour_tools.darken(constants.roadColour)
      ..strokeWidth = constants.roadWidth + 8 // * zoom
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final start = clockwise ? arcStart : arcEnd;
    final sweep = clockwise ? arcEnd - arcStart : arcStart - arcEnd;
    canvas.drawArc(Rect.fromCircle(center: centre, radius: radius), start,
        sweep, false, paint);
  }

  @override
  void drawBody({required Canvas canvas}) {
    final Paint paint = Paint()
      ..color = constants.roadColour
      ..strokeWidth = constants.roadWidth // * zoom
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final start = clockwise ? arcStart : arcEnd;
    final sweep = clockwise ? arcEnd - arcStart : arcStart - arcEnd;
    canvas.drawArc(Rect.fromCircle(center: centre, radius: radius), start,
        sweep, false, paint);
  }

  @override
  List<Object> get props => [centre, radius, clockwise, arcStart, arcEnd, id];
}

class CalculationRoad {
  static length(RenderRoad road) {
    if (road.type == RoadType.straight) {
      road = road as StraightRenderRoad;
      return (road.start - road.end).distance;
    } else {
      road = road as RenderArcRoad;
      double arcDif = (road.arcEnd - road.arcStart) * (road.clockwise ? 1 : -1);
      return (arcDif % (2 * pi)) * road.radius;
    }
  }

  static positionAt(RenderRoad road, {double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }
    fraction = distance != null ? distance / length(road) : fraction!;
    if (road.type == RoadType.straight) {
      road = road as StraightRenderRoad;

      return road.start + (road.end - road.start) * fraction;
    } else {
      road = road as RenderArcRoad;

      double arcDif = (road.arcEnd - road.arcStart) * (road.clockwise ? 1 : -1);
      double angle = road.arcStart + (arcDif * fraction);

      return Offset(road.centre.dx + sin(angle) * road.radius,
          road.centre.dy + cos(angle) * road.radius);
    }
  }

  static direction(RenderRoad road, {double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }
    fraction = distance != null ? distance / length(road) : fraction!;
    if (road.type == RoadType.straight) {
      road = road as StraightRenderRoad;
      double rotation = (road.end - road.start).direction;

      return ((rotation + (3 * pi / 2)) - (2 * pi)).abs();
    } else {
      road = road as RenderArcRoad;
      Offset travel = road.centre -
          positionAt(road, distance: distance, fraction: fraction);
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
  }
}
