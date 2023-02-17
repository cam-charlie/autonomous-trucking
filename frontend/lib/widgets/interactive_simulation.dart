import 'package:flutter/material.dart';
import 'package:frontend/widgets/move_detector.dart';
import 'package:frontend/widgets/move_detector_controller.dart';
import 'package:frontend/widgets/simulation_visualisation.dart';
import 'package:frontend/constants.dart' as constants;

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
    _controller = MoveDetectorController(tickerProvider: this);
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
        builder: (BuildContext context, _) =>
            SimulationVisualisation(
              state: constants.exampleState,
              transform: _controller.transform,
            ),
      ),
    );
  }
}
