import 'dart:math';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;

/// Road ID
class RID extends Equatable {
  const RID(int id) : _id = id;
  final int _id;

  @override
  List<Object> get props => [_id];
}

abstract class RenderRoad {
  const RenderRoad();

  RID get id;

  double get length;

  void draw({required Canvas canvas});

  Offset positionAt({double? distance, double? fraction});

  double direction({double? distance, double? fraction});
}

class StraightRenderRoad extends RenderRoad with EquatableMixin {
  final Offset start;
  final Offset end;

  @override
  final RID id;

  const StraightRenderRoad(
      {required this.id, required this.start, required this.end});

  @override
  void draw({required Canvas canvas}) {
    final Paint paint = Paint()
      ..color = constants.roadColour
      ..strokeWidth = constants.roadWidth // * zoom
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, paint);
  }

  @override
  double get length => (start - end).distance;

  @override
  Offset positionAt({double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }

    fraction = distance != null ? distance / length : fraction!;

    return start + (end - start) * fraction;
  }

  @override
  double direction({double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }

    Offset travel = end - start;

    if (travel.dy == 0) {
      return travel.dx > 0 ? pi / 2 : 3 * pi / 2;
    } else if (travel.dy > 0) {
      return travel.dx > 0
          ? atan(travel.dx / travel.dy)
          : 2 * pi - atan(travel.dx.abs() / travel.dy);
    } else {
      return travel.dx > 0
          ? pi / 2 + atan(travel.dy.abs() / travel.dx.abs())
          : travel.dx < 0
              ? 3 * pi / 2 - atan(travel.dy.abs() / travel.dx.abs())
              : pi;
    }
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
  double get length {
    double arcDif = (arcEnd - arcStart) * (clockwise ? 1 : -1);
    return (arcDif % (2 * pi)) * radius;
  }

  @override
  Offset positionAt({double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }

    fraction = distance != null ? distance / length : fraction!;

    double arcDif = (arcEnd - arcStart) * (clockwise ? 1 : -1);
    double angle = arcStart + (arcDif * fraction);

    return Offset(
        centre.dx + sin(angle) * radius, centre.dy + cos(angle) * radius);
  }

  @override
  double direction({double? distance, double? fraction}) {
    if ((distance == null) == (fraction == null)) {
      throw ArgumentError(
          "Exactly one of distance and fraction must be non-null");
    }

    Offset travel = centre - positionAt(distance: distance, fraction: fraction);
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

    return (angle + (clockwise ? -pi / 2 : pi / 2)) % (2 * pi);
  }

  @override
  List<Object> get props => [centre, radius, clockwise, arcStart, arcEnd, id];
}
