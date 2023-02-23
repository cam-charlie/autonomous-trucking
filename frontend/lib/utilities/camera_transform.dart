import 'dart:math';
import 'dart:ui';

/*
TODO:
 - finish worldToScreen etc functions and use them for something
 */

class CameraTransform {
  final Offset position;
  final double zoom;
  final double rotation;

  const CameraTransform(
      {required this.position, required this.zoom, required this.rotation});

  // (0,0) of "screen" is centre, whereas (0,0) of "canvas" is top left
  Offset worldToScreen(Offset worldPosition) {
    final pos = (worldPosition - position) * zoom;
    final c = cos(rotation), s = sin(rotation);
    final rpos = Offset(
      c*pos.dx + s*pos.dy,
      -s*pos.dx + c*pos.dy,
    );
    return rpos;
  }

  Offset screenToWorld(Offset canvasPosition) {
    final c = cos(-rotation), s = sin(-rotation);
    final zpos = Offset(
      c*canvasPosition.dx + s*canvasPosition.dy,
      -s*canvasPosition.dx + c*canvasPosition.dy,
    );
    final pos = (zpos / zoom) + position;
    return pos;
  }
}
