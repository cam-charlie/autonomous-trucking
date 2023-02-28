import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/utilities/velocity_calculator.dart';
import 'move_detector_controller.dart';

class MoveDetector extends StatelessWidget {
  final MoveDetectorController controller;
  final Widget? child;

  const MoveDetector({required this.controller, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: controller.scaleStart,
      onScaleUpdate: controller.scaleUpdate,
      onScaleEnd: controller.scaleEnd,
      child: child,
    );
  }
}