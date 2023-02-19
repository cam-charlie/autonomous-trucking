import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/utilities/animated_input_range.dart';
import 'package:frontend/utilities/camera_transform.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/utilities/velocity_calculator.dart';
import 'package:frontend/constants.dart' as constants;

/*
TODO:
  - [] add manual x, y, r, z, bounds, etc, changing
  - [] make zoom about cursor

 */

class MoveDetectorAnimationOptions {
  final AnimatedInputRangeBoundOptions boundOptions;
  final AnimatedInputRangeSlowStopOptions slowStopOptions;

  const MoveDetectorAnimationOptions(
      {required this.boundOptions, required this.slowStopOptions});
}

class MoveDetectorController extends ChangeNotifier {
  CameraTransform get transform =>
      CameraTransform(position: pan, zoom: zoom, rotation: rotation);

  Offset get pan => Offset(_xController.x, _yController.x);

  double get zoom => _zController.x;

  double get rotation => _rController.x;

  late final AnimatedInputRange _xController;
  late final AnimatedInputRange _yController;
  late final AnimatedInputRange _zController;
  late final AnimatedInputRange _rController;

  MoveDetectorController({
    required TickerProvider tickerProvider,
    required CameraTransform initialTransform,
    Rect panBounds = const Rect.fromLTRB(double.negativeInfinity,
        double.infinity, double.infinity, double.negativeInfinity),
    LogarithmicRange zoomBounds = const LogarithmicRange.all(),
    AngularRange rotationBounds = const AngularRange.all(),
    MoveDetectorAnimationOptions? panAnimations,
    MoveDetectorAnimationOptions? zoomAnimations,
    MoveDetectorAnimationOptions? rotateAnimations,
  }) {
    _xController = AnimatedInputRange(
      initialValue: initialTransform.position.dx,
      vsync: tickerProvider,
      slowStopOptions: panAnimations!.slowStopOptions,
      boundOptions: panAnimations!.boundOptions,
      bounds: LinearRange.fromRectW(panBounds),
      debug: true,
    )..addListener(notifyListeners);
    _yController = AnimatedInputRange(
      initialValue: initialTransform.position.dy,
      vsync: tickerProvider,
      slowStopOptions: panAnimations!.slowStopOptions,
      boundOptions: panAnimations!.boundOptions,
      bounds: LinearRange.fromRectH(panBounds),
    )..addListener(notifyListeners);
    _zController = AnimatedInputRange(
      initialValue: initialTransform.zoom,
      vsync: tickerProvider,
      slowStopOptions: zoomAnimations!.slowStopOptions,
      boundOptions: zoomAnimations!.boundOptions,
      bounds: zoomBounds,
    )..addListener(notifyListeners);
    _rController = AnimatedInputRange(
      initialValue: initialTransform.rotation,
      vsync: tickerProvider,
      slowStopOptions: rotateAnimations!.slowStopOptions,
      boundOptions: rotateAnimations!.boundOptions,
    )..addListener(notifyListeners);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    _rController.dispose();
    super.dispose();
  }

  Offset transformPanWithRotationAndZoom(Offset pan) {
    final s = sin(rotation), c = cos(-rotation);
    return Offset(
      -(c * pan.dx + s * pan.dy) / zoom,
      -(-s * pan.dx + c * pan.dy) / zoom,
    );
  }

  scaleStart(ScaleStartDetails details) {
    _xController.onStart();
    _yController.onStart();
    _zController.onStart();
    _rController.onStart();
  }

  scaleUpdate(ScaleUpdateDetails details) {
    _zController.onUpdate(
        details.scale, (double b, double c, double n) => b * n);

    _rController.onUpdate(
        details.rotation, (double b, double c, double n) => (b + n) % (2 * pi));

    final Offset translatedPan =
        transformPanWithRotationAndZoom(details.focalPointDelta);
    _xController.onUpdate(
        translatedPan.dx, (double b, double c, double n) => c + n);
    _yController.onUpdate(
        translatedPan.dy, (double b, double c, double n) => c + n);
  }

  scaleEnd(ScaleEndDetails details) {
    final translatedVelocity =
        transformPanWithRotationAndZoom(details.velocity.pixelsPerSecond);
    _xController.onEnd(translatedVelocity.dx);
    _yController.onEnd(translatedVelocity.dy);
    _zController.onEnd();
    _rController.onEnd();

    // TODO: prevent back swing animation
  }
}
