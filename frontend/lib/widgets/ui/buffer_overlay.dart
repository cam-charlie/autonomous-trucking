import 'package:flutter/material.dart';

class BufferOverlay extends StatelessWidget {
  final bool buffering;
  const BufferOverlay(
      {required this.buffering, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: buffering ? 0 : 1,
        child: Container(
          color: const Color(0xcc000000),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
