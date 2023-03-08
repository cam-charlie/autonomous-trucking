import 'dart:math';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/colour_tools.dart' as colour_tools;

/// Road ID
class RenderRoadID extends Equatable {
  const RenderRoadID(this.value);
  final int value;

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    return "RID($value)";
  }
}

// Final track of the Star Cup:
abstract class RenderRoad {
  const RenderRoad();

  RenderRoadID get id;

  void draw({required Canvas canvas});

  void drawOutline({required Canvas canvas});

  void drawBody({required Canvas canvas});
}

class RenderStraightRoad extends RenderRoad with EquatableMixin {
  final Offset start;
  final Offset end;
  @override
  final RenderRoadID id;

  const RenderStraightRoad(
      {required this.id, required this.start, required this.end});

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
  final RenderRoadID id;

  const RenderArcRoad(
      {required this.id,
      required this.centre,
      required this.radius,
      required double arcStart,
      required arcEnd,
      required this.clockwise})
      : arcStart = arcStart % (2 * pi),
        arcEnd = arcEnd % (2 * pi);

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

