import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/state/communication/Backend.dart';
import 'package:frontend/state/road.dart';
import 'state/interpolator.dart';
import 'package:frontend/state/simulation.dart';
import 'state/vehicle.dart';
import 'package:frontend/constants.dart' as constants;

/// the camera translation is handled by the MoveDetector.
/// this class stores the current timestamp, playback speed, and any selected cars
class AppController extends ChangeNotifier {
  SimulationState get state => _latestState;

  bool get buffering => bufferingNotifier.value;

  bool get pointerIsActive => activityNotifier.value;

  bool get playing => _playing;

  late SimulationState _latestState;
  late final ValueNotifier<bool> activityNotifier;
  late final ValueNotifier<bool> bufferingNotifier;
  late final ValueNotifier<SimulationState> stateNotifier;
  VID? _selectedVehicle = null;
  double _currentTime = 0;
  double _playbackSpeed = 1;
  bool _playing = true;

  late final Ticker _ticker;
  late final Interpolator _interpolator;

  AppController(TickerProvider tickerProvider) {
    _ticker = tickerProvider.createTicker(_tick)..start();
    bufferingNotifier = ValueNotifier(false);
    activityNotifier = ValueNotifier(false);
    stateNotifier = ValueNotifier(constants.exampleState);
    _interpolator = Interpolator(roads: [
      StraightRenderRoad(id: RID(1), start: Offset(0,0), end: Offset(0,200)),
    ]);
  }

  double _prevTime = 0;

  _tick(Duration elapsed) {
    _currentTime += _playbackSpeed * elapsed.inMicroseconds * 1000 * 1000;
    Buffering b = _interpolator.getBufferingState(_currentTime);
    bufferingNotifier.value = b.buffering;
    b.state.then((SimulationState s) => stateNotifier.value = s);
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
