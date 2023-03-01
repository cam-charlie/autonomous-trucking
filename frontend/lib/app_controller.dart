import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/state/communication/Backend.dart';
import 'package:frontend/state/simulation.dart';
import 'state/vehicle.dart';
import 'package:frontend/constants.dart' as constants;

SimulationState? getState(double t) => constants.exampleState;

/// the camera translation is handled by the MoveDetector.
/// this class stores the current timestamp, playback speed, and any selected cars
class AppController extends ChangeNotifier {
  SimulationState get state => _latestState;

  bool get buffering => bufferingNotifier.value;

  bool get pointerIsActive => activityNotifier.value;

  bool get playing => _playing;

  late final ValueNotifier<bool> activityNotifier;
  late SimulationState _latestState;
  late final ValueNotifier<bool> bufferingNotifier;
  VID? _selectedVehicle = null;
  double _currentTime = 0;
  double _playbackSpeed = 1;
  bool _playing = true;

  late final Ticker _ticker;

  AppController(TickerProvider tickerProvider) {
    _ticker = tickerProvider.createTicker(_tick);
    bufferingNotifier = ValueNotifier(false);
    activityNotifier = ValueNotifier(false);
  }

  _tick(Duration elapsed) {
    _currentTime += _playbackSpeed * elapsed.inMicroseconds * 1000 * 1000;
    // TODO: use actual `getState` when its finished
    SimulationState? s = getState(_currentTime);
    bufferingNotifier.value = s == null;
    if (!buffering) {
      _latestState = s!;
    }
  }

  onSpeedup() {
    _playbackSpeed += 0.25;
  }

  onPlayPause() {
    _playing = !_playing;
  }

  onSlowdown() {
    _playbackSpeed = min(0.25, _playbackSpeed - 0.25);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // TODO: change use of `state` to whatever internal thing we use
  void onTap(Offset tapPosition) {
    // TODO: find closest vehicle to tap within radius
    final VID? closestVehicle = _findClosestVehicle(tapPosition);
    _selectedVehicle = closestVehicle;
  }

  VID? _findClosestVehicle(Offset position) {
    double closestDistance = double.infinity;
    VID? closestVehicle;
    for (Vehicle v in state.vehicles) {
      final d = (position - v.position).distance;
      if (d < constants.vehicleSelectionRadius && d < closestDistance) {
        closestDistance = d;
        closestVehicle = v.id;
      }
    }
    return closestVehicle;
  }
}
