import 'package:flutter/material.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/state/render_depot.dart';
import 'package:frontend/state/render_outline.dart';
import 'package:frontend/utilities/camera_transform.dart';

import '../../state/render_road.dart';
import '../../state/render_simulation.dart';
import '../../state/render_text.dart';
import '../../state/render_vehicle.dart';

class SimulationVisualisation extends StatelessWidget {
  final RenderSimulationState state;
  final CameraTransform transform;

  const SimulationVisualisation(
      {required this.state, required this.transform, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SimulationPainter(
        state: state,
        transform: transform,
      ),
    );
  }
}

class SimulationPainter extends CustomPainter {
  final RenderSimulationState state;
  final CameraTransform transform;

  Offset get position => transform.position;

  double get zoom => transform.zoom;

  double get rotation => transform.rotation;

  const SimulationPainter({required this.state, required this.transform});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = constants.backgroundColour
          ..style = PaintingStyle.fill);

    // ensure you don't draw outside of the canvas
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    // move the canvas' origin to the centre of the widget
    canvas.translate(size.width / 2, size.height / 2);
    // move to the correct CameraTransform
    canvas.rotate(rotation);
    canvas.scale(zoom);
    canvas.translate(-position.dx, -position.dy);

    // for (RenderRoad r in state.roads) {
    //   r.drawOutline(canvas: canvas);
    // }

    for (RenderRoad r in state.roads) {
      r.drawBody(canvas: canvas);
    }

    for (RenderVehicle v in state.vehicles) {
      v.drawShadow(canvas: canvas);
    }
    for (RenderVehicle v in state.vehicles) {
      v.drawBody(canvas: canvas);
    }
    for (RenderDepot d in state.depots) {
      d.drawShadow(canvas: canvas);
    }
    for (RenderDepot d in state.depots) {
      d.drawBody(canvas: canvas);
    }
    for (RenderOutline o in state.outlines) {
      o.draw(canvas: canvas);
    }
    for (RenderText t in state.text) {
      t.draw(canvas: canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! SimulationPainter ||
        position != oldDelegate.position ||
        zoom != oldDelegate.zoom ||
        rotation != oldDelegate.rotation ||
        state != oldDelegate.state;
  }
}
