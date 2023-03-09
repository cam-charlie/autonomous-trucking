import 'dart:ui';

class RenderOutline {
  final List<Offset> points;

  const RenderOutline(this.points);

  Path calcPath() {
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (final point in points.sublist(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    return path;
  }



  void draw({required Canvas canvas}) {
    final paint = Paint()
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..color = Color(0x40000000)
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(calcPath(), paint);
  }
}
