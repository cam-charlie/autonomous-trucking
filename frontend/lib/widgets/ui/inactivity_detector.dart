import 'dart:async';

import 'package:flutter/material.dart';

class InactivityDetector extends StatefulWidget {
  final Widget child;
  final Duration inactiveTimeout;
  final VoidCallback? onActivity;
  final VoidCallback? onInactivity;

  InactivityDetector(
      {required this.inactiveTimeout,
      this.onActivity,
      this.onInactivity,
      required this.child,
      super.key});

  @override
  State<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends State<InactivityDetector> {
  _InactivityDetectorState() : timer = Timer(Duration.zero, () {});

  Timer timer;

  void registerActivity(_) {
    if (timer.isActive) {
      timer.cancel();
    } else {
      widget.onActivity?.call();
    }
    timer = Timer(widget.inactiveTimeout, () {
      widget.onInactivity?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: registerActivity,
      onPointerHover: registerActivity,
      onPointerMove: registerActivity,
      onPointerPanZoomUpdate: registerActivity,
      child: widget.child,
    );
  }
}
