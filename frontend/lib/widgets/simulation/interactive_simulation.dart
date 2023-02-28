import 'package:flutter/material.dart';
import 'package:frontend/utilities/animated_input_range.dart';
import 'package:frontend/utilities/camera_transform.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/constants.dart' as constants;
import 'move_detector/move_detector.dart';
import 'move_detector/move_detector_controller.dart';
import 'simulation_visualisation.dart';

class InteractiveSimulation extends StatefulWidget {
  const InteractiveSimulation({super.key});

  @override
  State<InteractiveSimulation> createState() => _InteractiveSimulationState();
}

class _InteractiveSimulationState extends State<InteractiveSimulation>
    with TickerProviderStateMixin {
  late MoveDetectorController _controller;

  @override
  void initState() {
    super.initState();
    const moveDetectorAnimationOptions = MoveDetectorAnimationOptions(
        boundOptions: AnimatedInputRangeBoundOptions(
            stretchSpace: 300, snapBackTime: Duration(milliseconds: 300)),
        slowStopOptions: AnimatedInputRangeSlowStopOptions(
            drag: constants.translateDragCoefficient));
    _controller = MoveDetectorController(
      tickerProvider: this,
      initialTransform:
          const CameraTransform(position: Offset(0, 0), rotation: 0, zoom: 1),
      panBounds: Rect.fromCenter(center: Offset.zero, width: 500, height: 500),
      zoomBounds: const LogarithmicRange(0.1, 10),
      panAnimations: moveDetectorAnimationOptions,
      zoomAnimations: moveDetectorAnimationOptions,
      rotateAnimations: moveDetectorAnimationOptions,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MoveDetector(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) => SimulationVisualisation(
          state: constants.exampleState,
          transform: _controller.transform,
        ),
      ),
    );
  }
}
