import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/utilities/velocity_calculator.dart';
import 'package:frontend/constants.dart' as constants;

/*
TODO:
  - add bounds detection and animation to stop out of bounds panning and zooming.
 */

class MoveDetectorController extends ChangeNotifier {
  Rect _positionBounds;
  Range _zoomBounds;
  Range _rotationBounds;

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
        _zoom = _acz.value;
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

  panStart(DragStartDetails details) {
    _acx.stop();
    _acy.stop();
    _acz.stop(); // should stop zooming when user pans
    _acr.stop();
  }

  panUpdate(DragUpdateDetails details) {
    if (_canPan) {
      _x += details.delta.dx / _zoom;
      _y += details.delta.dy / _zoom;
    }
    notifyListeners();
  }

  panEnd(DragEndDetails details) {
    // acx.value = x;
    // acy.value = y;
    _animatePostPan(Offset(_x, _y), details.velocity.pixelsPerSecond);
    // TODO: animate into bounds if out of bounds
  }

  scaleStart(ScaleStartDetails details) {
    _acx.stop(); // should stop panning when user zooms
    _acy.stop();
    _acz.stop();
    _acr.stop();
    _baseZoom = 1;
    _baseRotation = 0;
    _zoomVelocityCalculator.reset();
    _rotateVelocityCalculator.reset();
  }

  scaleUpdate(ScaleUpdateDetails details) {
    if (_canPan) {
      _x += details.focalPointDelta.dx;
      _y += details.focalPointDelta.dy;
    }
    if (_canZoom) {
      _zoom = _baseZoom * details.scale;
    }
    if (_canRotate) {
      _rotation = (_baseRotation + details.rotation) % (2 * pi);
    }
    _zoomVelocityCalculator.pushValue(details.scale);
    _rotateVelocityCalculator.pushValue(details.rotation);
    notifyListeners();
  }

  scaleEnd(ScaleEndDetails details) {
    // acx.value = x;
    // acy.value = y;
    if (_canPan) {
      _animatePostPan(Offset(_x, _y), details.velocity.pixelsPerSecond);
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
    _acr.animateWith(FrictionSimulation(constants.zoomDragCoefficient, r, rv));
  }
}
