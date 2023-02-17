import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/utilities/camera_transform.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/utilities/velocity_calculator.dart';
import 'package:frontend/constants.dart' as constants;

/*
TODO:
  - add bounds detection and animation to stop out of bounds panning and zooming.
  - add manual x, y, r, z, bounds, etc, changing
  - make zoom about cursor
 */

class MoveDetectorController extends ChangeNotifier {
  Rect _positionBounds;
  Range _zoomBounds;
  Range _rotationBounds;

  CameraTransform get transform => CameraTransform(
      position: Offset(_x, _y), zoom: _zoom, rotation: _rotation);

  double get x => _x;
  double _x;

  double get y => _y;
  double _y;
  bool _canPan;

  double get zoom => _zoom;
  late double _baseZoom;
  double _zoom;
  bool _canZoom;

  double get rotation => _rotation;
  late double _baseRotation;
  double _rotation;
  bool _canRotate;

  final TickerProvider _tickerProvider;

  final VelocityCalculator _zoomVelocityCalculator = VelocityCalculator();
  final VelocityCalculator _rotateVelocityCalculator = VelocityCalculator();

  late AnimationController _acx; // x-axis
  late AnimationController _acy; // y-axis
  late AnimationController _acz; // zoom
  late AnimationController _acr; // rotation

  MoveDetectorController(
      {required TickerProvider tickerProvider,
      bool pan = true,
      Offset? initialPosition,
      Rect? positionBounds,
      bool zoom = true,
      double? initialZoom,
      LinearRange? zoomBounds,
      bool rotate = true,
      double? initialRotation,
      LogarithmicRange? rotationBounds})
      : _canPan = pan,
        _x = initialPosition?.dx ?? positionBounds?.center.dx ?? 0,
        _y = initialPosition?.dy ?? positionBounds?.center.dy ?? 0,
        _positionBounds = positionBounds ??
            const Rect.fromLTRB(double.negativeInfinity, double.infinity,
                double.infinity, double.negativeInfinity),
        _canZoom = zoom,
        _zoom = initialZoom ?? zoomBounds?.center ?? 1,
        _zoomBounds = zoomBounds ?? const LogarithmicRange(0, double.infinity),
        _canRotate = rotate,
        _rotation = initialRotation ?? rotationBounds?.center ?? 0,
        _rotationBounds = rotationBounds ?? const AngularRange.all(),
        _tickerProvider = tickerProvider {
    _acx = AnimationController.unbounded(vsync: _tickerProvider)
      ..addListener(() {
        _x = _acx.value;
        notifyListeners();
      });

    _acy = AnimationController.unbounded(vsync: _tickerProvider)
      ..addListener(() {
        _y = _acy.value;
        notifyListeners();
      });

    _acz = AnimationController.unbounded(vsync: _tickerProvider)
      ..addListener(() {
        _zoom = max(_acz.value, 0.1); // TODO: make this into proper bounds
        notifyListeners();
      });

    _acr = AnimationController.unbounded(vsync: _tickerProvider)
      ..addListener(() {
        _rotation = _acr.value;
        notifyListeners();
      });
  }

  updateBounds(
      {Rect? positionBounds,
      LogarithmicRange? zoomBounds,
      AngularRange? rotationBounds}) {
    _positionBounds = positionBounds ?? _positionBounds;
    _zoomBounds = zoomBounds ?? _zoomBounds;
    _rotationBounds = rotationBounds ?? _rotationBounds;
    // TODO: animate away if out of bounds. what if already animating away from out of bounds?
  }

  @override
  void dispose() {
    _acx.dispose();
    _acy.dispose();
    _acz.dispose();
    _acr.dispose();
    super.dispose();
  }

  transformPanWithRotationAndZoom(Offset pan) {
    final s = sin(_rotation), c = cos(-rotation);
    return Offset(
      -(c * pan.dx + s * pan.dy) / zoom,
      -(-s * pan.dx + c * pan.dy) / zoom,
    );
  }

  scaleStart(ScaleStartDetails details) {
    _acx.stop(); // should stop panning when user zooms
    _acy.stop();
    _acz.stop();
    _acr.stop();
    _baseZoom = zoom;
    _baseRotation = _rotation;
    _zoomVelocityCalculator.reset();
    _rotateVelocityCalculator.reset();
  }

  scaleUpdate(ScaleUpdateDetails details) {
    if (_canRotate) {
      _rotation = (_baseRotation + details.rotation) % (2 * pi);
    }
    if (_canZoom) {
      // TODO: make it zoom around the cursor. does it already handle two fingers?
      _zoom = _baseZoom * details.scale;
    }
    if (_canPan) {
      final pan = transformPanWithRotationAndZoom(details.focalPointDelta);
      _x += pan.dx;
      _y += pan.dy;
    }
    _zoomVelocityCalculator.pushValue(details.scale);
    _rotateVelocityCalculator.pushValue(details.rotation);
    notifyListeners();
  }

  scaleEnd(ScaleEndDetails details) {
    // TODO: prevent back swing animation
    if (_canPan) {
      _animatePostPan(Offset(_x, _y),
          transformPanWithRotationAndZoom(details.velocity.pixelsPerSecond));
    }
    if (_canZoom) {
      _animatePostScale(_zoom, _zoomVelocityCalculator.velocity);
    }
    if (_canRotate) {
      _animatePostRotate(_rotation, _rotateVelocityCalculator.velocity);
    }
    // TODO: animate back into bounds if out
  }

  _animatePostPan(Offset position, Offset velocity) {
    _acx.animateWith(FrictionSimulation(
        constants.panDragCoefficient, position.dx, velocity.dx));
    _acy.animateWith(FrictionSimulation(
        constants.panDragCoefficient, position.dy, velocity.dy));
  }

  _animatePostScale(double z, double zv) {
    _acz.animateWith(FrictionSimulation(constants.zoomDragCoefficient, z, zv));
  }

  _animatePostRotate(double r, double rv) {
    _acr.animateWith(
        FrictionSimulation(constants.rotateDragCoefficient, r, rv));
  }
}
