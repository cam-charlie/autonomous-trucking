import 'dart:math';
import 'dart:ui';
import 'package:equatable/equatable.dart';

class RID extends Equatable {
  const RID(int id) : _id = id;
  final int _id;
  @override
  List<Object> get props => [_id];
}

abstract class Road {
  const Road();
  RID get id;
  double get length;

  Offset positionAt({double? distance, double? fraction});
}



class StraightRoad extends Road {
  final Offset start;
  final Offset end;

  @override
  final RID id;

  const StraightRoad({required this.id, required this.start, required this.end});

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

}



class ArcRoad extends Road {
  final Offset centre;
  final double radius;
  final bool clockwise;

  /// Radians from north this road arc starts
  final double arcStart;

  /// Radians from north this road arc ends
  final double arcEnd;

  @override
  final RID id;

  const ArcRoad({required this.id, required this.centre,
    required this.radius, required double arcStart, required arcEnd, required this.clockwise})
      : arcStart = arcStart % (2 * pi),
        arcEnd = arcEnd % (2 * pi);

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
}