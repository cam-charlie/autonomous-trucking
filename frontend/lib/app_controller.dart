import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/constants.dart' as constants;
import 'package:frontend/generation/file_to_store.dart';
//import 'package:frontend/generation/rstore_to_store.dart';
import 'package:frontend/generation/store_state.dart';
import 'package:frontend/generation/store_to_json.dart';
import 'package:frontend/generation/store_to_render.dart';
import 'package:frontend/state/communication/Backend.dart';
import 'package:frontend/state/render_depot.dart';
import 'package:frontend/state/render_road.dart';
import 'package:frontend/state/render_simulation.dart';

//import 'generation/file_to_rstore.dart';
//import 'generation/rstore_state.dart';
import 'state/interpolator.dart';
import 'state/render_vehicle.dart';

/// the camera translation is handled by the MoveDetector.
/// this class stores the current timestamp, playback speed, and any selected cars
class AppController extends ChangeNotifier {
  RenderSimulationState get state => _latestState;

  bool get buffering => bufferingNotifier.value;

  bool get pointerIsActive => activityNotifier.value;

  bool get playing => _playing;

  late RenderSimulationState _latestState;
  late final ValueNotifier<bool> activityNotifier;
  late final ValueNotifier<bool> bufferingNotifier;
  late final ValueNotifier<RenderSimulationState> stateNotifier;
  RenderVehicleID? _selectedVehicle = null;
  double _currentTime = 0;
  double _playbackSpeed = 5;
  bool _playing = true;

  late final Ticker _ticker;
  late final Interpolator _interpolator;
  bool _initialStateLoadedFromFile = false;

  AppController(TickerProvider tickerProvider) {
    _ticker = tickerProvider.createTicker(_tick)..start();
    bufferingNotifier = ValueNotifier(true);
    activityNotifier = ValueNotifier(false);
    stateNotifier = ValueNotifier(constants.exampleState);
    // initial state

    _setupNetwork();
  }

  void _setupNetwork() async {
    String yamlData = await rootBundle.loadString('assets/state.yaml');
    final StoreSimulationState storeState = loadFileIntoStoreState(yamlData);
    await startFromConfig(convertStoreStateToJson(storeState));
    // String yamlData = await rootBundle.loadString('assets/rstate.yaml');
    // final RStoreSimulationState rStoreState = loadFileIntoRStoreState(yamlData);
    // final StoreSimulationState storeState = convertRStoreToStoreSimulationState(rStoreState);
    await startFromConfig(convertStoreStateToJson(storeState));

    final StaticRenderData data = convertStoreStateToRenderData(storeState);
    // TODO: pass to will's function on init
    final List<RenderDepot> depots =
        convertStoreStateToRenderDepots(storeState);
    _interpolator = Interpolator(data: data);
    bufferingNotifier.value = false;
    _initialStateLoadedFromFile = true;
  }

  int _lastElapsed = 0;

  _tick(Duration elapsed) {
    int changeInTime = elapsed.inMicroseconds - _lastElapsed;
    _lastElapsed = elapsed.inMicroseconds;
    if (!_playing || !_initialStateLoadedFromFile) return;
    _currentTime += _playbackSpeed * changeInTime / (1000 * 1000);
    Buffering b = _interpolator.getBufferingState(_currentTime);
    bufferingNotifier.value = b.buffering;
    b.state.then((RenderSimulationState s) => stateNotifier.value = s);
  }

  onSpeedup() {
    _playbackSpeed += 0.25;
  }

  onPlayPause() {
    _playing = !_playing;
  }

  onSlowdown() {
    _playbackSpeed = max(0.25, _playbackSpeed - 0.25);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // TODO: change use of `state` to whatever internal thing we use
  void onTap(Offset tapPosition) {
    // TODO: find closest vehicle to tap within radius
    final RenderVehicleID? closestVehicle = _findClosestVehicle(tapPosition);
    _selectedVehicle = closestVehicle;
  }

  RenderVehicleID? _findClosestVehicle(Offset position) {
    double closestDistance = double.infinity;
    RenderVehicleID? closestVehicle;
    for (RenderVehicle v in state.vehicles) {
      final d = (position - v.position).distance;
      if (d < constants.vehicleSelectionRadius && d < closestDistance) {
        closestDistance = d;
        closestVehicle = v.id;
      }
    }
    return closestVehicle;
  }
}
