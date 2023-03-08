import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/velocity_calculator.dart';
import 'move_detector_controller.dart';

class MoveDetector extends StatelessWidget {
  final MoveDetectorController controller;
  final Size? size;
  final Widget? child;

  const MoveDetector(
      {required this.controller, this.size, this.child, super.key});

  void onTap(TapUpDetails details) {
    if (size != null) controller.tap(details, size!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTap,
      onScaleStart: controller.scaleStart,
      onScaleUpdate: controller.scaleUpdate,
      onScaleEnd: controller.scaleEnd,
      child: child,
    );
  }
}
