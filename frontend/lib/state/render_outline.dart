import 'dart:ui';

class RenderOutline {
  final List<Offset> points;

  const RenderOutline(this.points);

  Path calcPath() {
    final path = Path();
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    return path;
  }

  void draw({required Canvas canvas}) {
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..color = Color(0x80000000)
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(calcPath(), paint);
  }
}
