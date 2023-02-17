import 'package:flutter/material.dart';
import 'package:frontend/widgets/interactive_simulation.dart';

void main() {
  runApp(TruckingApp());
}

class TruckingApp extends StatelessWidget {
  TruckingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveSimulation();
  }

}