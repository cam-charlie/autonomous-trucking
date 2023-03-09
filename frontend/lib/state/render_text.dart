import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenderText {
  final String text;
  final Offset position;

  const RenderText(this.text, this.position);

  void draw({required Canvas canvas}) {
    final p =
        TextPainter(text: TextSpan(text: text, style: TextStyle(color: Color(0x80000000))), textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    p.layout();
    p.paint(canvas, position);
    p.dispose();
  }
}
