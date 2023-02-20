import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/utilities/velocity_calculator.dart';

/*
TODO
  -[ ] when slow-stopping into a boundary, it should bounce back with velocity, not just stop immediately.
*/

class AnimatedInputRangeSlowStopOptions {
  final double drag;

  const AnimatedInputRangeSlowStopOptions({required this.drag});
}

class AnimatedInputRangeBoundOptions {
  final double stretchSpace;
  final Duration snapBackTime;

  const AnimatedInputRangeBoundOptions(
      {required this.stretchSpace, required this.snapBackTime});
}

class AnimatedInputRange extends ChangeNotifier {
  double get x => _x;
  double _x;

  late double _noBoundsX;
  late double _baseX;

  final Range _bounds;

  bool get _shouldAnimateBounds =>
      _boundOptions != null &&
      _boundOptions!.snapBackTime > Duration.zero &&
      _boundOptions!.stretchSpace > 0;
  final AnimatedInputRangeBoundOptions? _boundOptions;

  bool get _shouldAnimateSlowStop =>
      _slowStopOptions != null && _slowStopOptions!.drag < 1;
  final AnimatedInputRangeSlowStopOptions? _slowStopOptions;

  late final AnimationController _controller;
  final VelocityCalculator _velocityCalculator = VelocityCalculator();

  bool debug;

  AnimatedInputRange({
    required double initialValue,
    required TickerProvider vsync,
    Range bounds = const LinearRange.all(),
    AnimatedInputRangeBoundOptions? boundOptions,
    AnimatedInputRangeSlowStopOptions? slowStopOptions,
    this.debug = false,
  })  : _x = initialValue,
        _bounds = bounds,
        _boundOptions = boundOptions,
        _slowStopOptions = slowStopOptions,
        _controller = AnimationController.unbounded(vsync: vsync);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void log(s) {
    if (debug) print(s);
  }

  /* ---------- start, update, & end callbacks ---------- */

  void onStart([double? nx]) {
    _resetController();
    _velocityCalculator.reset(value: nx);

    _baseX = _x;
    _noBoundsX = _x;
  }

  void onUpdate(
      double nx,
      double Function(
              double startingValue, double currentValue, double newValue)
          updateFunction) {
    _noBoundsX = updateFunction(_baseX, _noBoundsX, nx);
    _x = _mappedX(_baseX, _noBoundsX);
    _velocityCalculator.pushValue(_x);
    notifyListeners();
  }

  void onEnd([double? velocity]) {
    final pos = _x, vel = velocity ?? _velocityCalculator.velocity;
    if (!_bounds.contains(pos)) {
      _animateBackToBounds(pos, vel);
    } else if (_shouldAnimateSlowStop) {
      _animateSlowStop(pos, vel);
    }
  }

  /* ---------- bounding methods ---------- */

  double _mappedX(double base, double x) {
    double offset = base - _slowDownBoundsCalculator(base); // TODO: turn into field for better performance
    return _slowDownBoundsCalculator(x) + offset;
  }


  // TODO: should take into account the base position of _x. its an offset?
  double _slowDownBoundsCalculator(double x) {
    if (_bounds.contains(x)) return x;

    if (_shouldAnimateBounds) {
      final edge = _bounds.clamp(x);
      final distance = _bounds.distance(x);
      final extra = _boundOptions!.stretchSpace *
          (1 - (1 / ((distance / _boundOptions!.stretchSpace) + 1)));
      return (x < _bounds.min) ? edge - extra : edge + extra;
    } else {
      return _bounds.clamp(x);
    }
  }

  /* ---------- stop and start animating methods ---------- */

  void _resetController() {
    _controller.stop();
    _controller.removeListener(_onSlowDownBoundsAnimationUpdate);
    _controller.removeListener(_onSlowStopAnimationUpdate);
  }

  void _animateBackToBounds(double pos, double vel) {
    _resetController();
    if (!_shouldAnimateBounds) {
      _x = _bounds.clamp(pos);
      notifyListeners();
    } else {
      _controller.value = pos;
      _controller
        ..addListener(_onSlowDownBoundsAnimationUpdate)
        ..animateTo(
          _bounds.clamp(pos),
          duration: _boundOptions!.snapBackTime,
          curve: Curves.ease,
        );
    }
  }

  void _animateSlowStop(double pos, double vel) {
    _resetController();
    _controller
      ..addListener(_onSlowStopAnimationUpdate)
      ..animateWith(FrictionSimulation(_slowStopOptions!.drag, pos, vel));
  }

  /* ---------- animation update methods ---------- */

  void _onSlowDownBoundsAnimationUpdate() {
    _x = _controller.value;
    _velocityCalculator.pushValue(_x);
    notifyListeners();
  }

  void _onSlowStopAnimationUpdate() {
    _x = _controller.value;
    if (!_bounds.contains(_x)) {
      _animateBackToBounds(_x, _velocityCalculator.velocity);
    }
    _velocityCalculator.pushValue(_x);
    notifyListeners();
  }
}