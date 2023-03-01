import 'package:flutter/material.dart';
import 'package:frontend/state/communication/Backend.dart';
import 'package:frontend/widgets/simulation/interactive_simulation.dart';
import 'package:frontend/widgets/ui/control.dart';
import 'package:frontend/widgets/ui/inactivity_detector.dart';
import 'package:frontend/widgets/ui/ui_overlay.dart';
import 'package:frontend/widgets/ui/comms_widget.dart';

void main() {
  startFromConfig(1);
  runApp(TruckingApp());
}

class TruckingApp extends StatefulWidget {
  TruckingApp({super.key});

  @override
  State<TruckingApp> createState() => _TruckingAppState();
}

class _TruckingAppState extends State<TruckingApp> {
  bool _controlVisible = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InactivityDetector(
        onActivity: () => setState(() => _controlVisible = true),
        onInactivity: () => setState(() => _controlVisible = false),
        inactiveTimeout: const Duration(seconds: 1),
        child: Stack(
          children: [
            Positioned.fill(child: InteractiveSimulation()),
            // Positioned.fill(
            UIOverlay(
              controlVisible: _controlVisible,
            ),
            CommsWidget(),

            // ),
          ],
        ),
      ),
    );
  }
}
