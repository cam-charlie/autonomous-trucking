import 'dart:math';
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
    drawShadow(canvas: canvas);
    drawBody(canvas: canvas);
  }

  void drawBody({required Canvas canvas}) {
    final depotFillPaint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;
    final depotStrokePaint = Paint()
      ..color = colour_tools.darken(colour)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(position, 15, depotFillPaint);
    canvas.drawCircle(position, 15, depotStrokePaint);
  }

  void drawShadow({required Canvas canvas}) {
    final r = 17;
    final offset = Offset(8,8);
    final rectPoints = [
      position + Offset(-sqrt1_2*r, sqrt1_2*r),
      position + Offset(sqrt1_2*r, -sqrt1_2*r),
      position + Offset(sqrt1_2*r, -sqrt1_2*r) + offset,
      position + Offset(-sqrt1_2*r, sqrt1_2*r) + offset,
    ];
    Path path = Path()
      ..addPolygon(rectPoints, true)
      ..addOval(Rect.fromCenter(
          center: position + offset, width: r*2, height: r*2));

    canvas.drawShadow(path, Color(0xff000000), 0, false);
  }

  @override
  List<Object> get props => [position, id];
}
