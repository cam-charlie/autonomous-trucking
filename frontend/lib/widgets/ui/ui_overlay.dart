import 'package:flutter/material.dart';
import 'package:frontend/widgets/ui/inactivity_detector.dart';

import 'control.dart';

class UIOverlay extends StatefulWidget {
  UIOverlay({this.controlVisible = true, super.key});
  final bool controlVisible;

  @override
  State<UIOverlay> createState() => _UIOverlayState();
}

class _UIOverlayState extends State<UIOverlay> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ControlUI(
        visible: widget.controlVisible,
        children: [],
      ),
    );
  }
}
