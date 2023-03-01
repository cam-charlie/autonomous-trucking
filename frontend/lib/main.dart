import 'package:flutter/material.dart';
import 'package:frontend/app_controller.dart';
import 'package:frontend/state/communication/Backend.dart';
import 'package:frontend/widgets/simulation/interactive_simulation.dart';
import 'package:frontend/widgets/ui/control.dart';
import 'package:frontend/widgets/ui/inactivity_detector.dart';
import 'package:frontend/widgets/ui/comms_widget.dart';

import 'widgets/ui/buffer_overlay.dart';

void main() {
  startFromConfig(1);
  runApp(TruckingApp());
}

class TruckingApp extends StatefulWidget {
  TruckingApp({super.key});

  @override
  State<TruckingApp> createState() => _TruckingAppState();
}

class _TruckingAppState extends State<TruckingApp> with SingleTickerProviderStateMixin {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TODO: change `setState` to `AnimatedBuilder` on `ValueNotifier`
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InactivityDetector(
        onActivity: () => setState(() => _controller.activityNotifier.value = true),
        onInactivity: () => setState(() => _controller.activityNotifier.value = false),
        inactiveTimeout: const Duration(seconds: 2),
        child: Stack(
          children: [
            const Positioned.fill(child: InteractiveSimulation()),
            const BufferOverlay(buffering: true),
            ControlUI(
              playing: _controller.playing,
              mouseActive: _controller.activityNotifier.value,
              onPlayPause: () => setState(() => _controller.onPlayPause()),
              onBackwards: () => setState(() => _controller.onSlowdown()),
              onForwards: () => setState(() => _controller.onSpeedup()),
            ),
            const CommsWidget(),
          ],
        ),
      ),
    );
  }
}
