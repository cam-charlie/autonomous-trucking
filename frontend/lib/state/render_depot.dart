import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/colour_tools.dart' as colour_tools;

/// Vehicle ID
class RenderDepotID extends Equatable {
  const RenderDepotID(this.value);

  final int value;

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    return "NID($value)";
  }
}

class RenderDepot with EquatableMixin {
  final Offset position;
  final RenderDepotID id;

  Color get colour =>
      constants.vehicleColours[id.hashCode % constants.vehicleColours.length];

  const RenderDepot({required this.id, required this.position});

  void draw({required Canvas canvas}) {
    final depotFillPaint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;
    final depotStrokePaint = Paint()
      ..color = colour_tools.darken(colour)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (position == double.nan) print(id);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: position, width: 30, height: 30),
            const Radius.circular(5)),
        depotFillPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: position, width: 30, height: 30),
            const Radius.circular(5)),
        depotStrokePaint);
  }

  @override
  List<Object> get props => [position, id];
}
