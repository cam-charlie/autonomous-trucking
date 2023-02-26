import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/colour_tools.dart' as colour_tools;

import '../../utilities/canvas_drawing.dart';

/// Vehicle ID
class VID extends Equatable {
  const VID(int id) : _id = id;
  final int _id;

  @override
  List<Object> get props => [_id];

  @override
  String toString() {
    return "VID($_id)";
  }
}

class Vehicle with EquatableMixin {
  final Offset position;
  final double direction; // radians
  final VID id;

  Color get colour =>
      constants.vehicleColours[id.hashCode % constants.vehicleColours.length];

  const Vehicle(
      {required this.id, required this.position, required this.direction});

  void draw({required Canvas canvas}) {
    drawShadow(canvas: canvas);
    drawBody(canvas: canvas);
  }

  drawBody({required Canvas canvas}) {
    final vehicleFillPaint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;
    final vehicleStrokePaint = Paint()
      ..color = colour_tools.darken(colour)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    drawRotated(
        canvas: canvas,
        point: position,
        rotation: direction,
        f: () {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: position,
                    width: constants.carSize.width,
                    height: constants.carSize.height),
                const Radius.circular(2)),
            vehicleFillPaint,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: position,
                    width: constants.carSize.width,
                    height: constants.carSize.height),
                const Radius.circular(2)),
            vehicleStrokePaint,
          );
        });
  }

  drawShadow({required Canvas canvas}) {
    final shadowPaint = Paint()
      ..color = constants.shadowColour
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    final shadowPos = position + const Offset(2, 2);

    drawRotated(
        canvas: canvas,
        point: shadowPos,
        rotation: direction,
        f: () => canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromCenter(
                      center: shadowPos,
                      width: constants.carSize.width + 2,
                      height: constants.carSize.height + 2),
                  const Radius.circular(2)),
              shadowPaint,
            ));
  }

  @override
  List<Object> get props => [position, direction, id];
}
