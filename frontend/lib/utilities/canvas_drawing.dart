import 'dart:ui';

rotateCanvasAboutPoint(
    {required Canvas canvas,
      required Offset point,
      required double rotation}) {
  canvas.translate(point.dx, point.dy);
  canvas.rotate(rotation);
  canvas.translate(-point.dx, -point.dy);
}

drawRotated(
    {required Canvas canvas,
      required Offset point,
      required double rotation,
      required VoidCallback f}) {
  canvas.save();
  rotateCanvasAboutPoint(canvas: canvas, point: point, rotation: rotation);
  f();
  canvas.restore();
}