import 'package:flutter/material.dart';

void main() {
  runApp(TruckingApp());
}

class TruckingApp extends StatelessWidget {
  TruckingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Center(
        child: Text('Autonomous Trucking'),
      ),
    );
  }

}