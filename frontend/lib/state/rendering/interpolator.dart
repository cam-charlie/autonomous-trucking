import 'package:frontend/state/rendering/road.dart';
import 'package:frontend/state/rendering/simulation.dart';
import 'package:frontend/state/rendering/vehicle.dart';
import 'package:collection/collection.dart';
import 'faketrucking.dart';

// TODO: Testing
class Interpolator {
  final List<RenderRoad> roads;

  const Interpolator({required this.roads});

  // Find the % of road covered
  double _truckDistCovered(Truck start, Truck end, double time, double frac) {
    /*
    double interspeed = (frac * ( endspeed - startspeed)) + startspeed;
    double totaldist = (startspeed + endspeed) * time * 0.5;
    double interdist = (startspeed + interspeed) * frac * time * 0.5;
    double fracdist = interdist/totaldist;
    ^ This is the above reorganised to have no allocations
    */
    return ((end.progress + end.roadId == start.roadId ? 0 : 1.0) -
            start.progress) *
        ((start.currSpeed +
                ((frac * (end.currSpeed - start.currSpeed)) +
                    start.currSpeed)) *
            frac *
            time *
            0.5) /
        ((start.currSpeed + end.currSpeed) * time * 0.5);
  }

  // Determine if truck has switched between raod A and road B

  bool _truckRoadChange(Truck start, Truck end, double time, double frac) {
    return start.progress + _truckDistCovered(start, end, time, frac) > 1;
  }

  // Generates new SimulationState for rendering
  Future<SimulationState> getState({double time = 0.0}) async {
    // TODO: Dart refuses to allow constant maps, any ideas to fix this would be appreciated

    Map<RID, RenderRoad> roadMap =
        Map.fromIterable(roads.map((e) => {e.id: e}));

    List<TruckPositionsAtTime> positions = await getPositionData(time);

    // time == generated time т, state matches generation

    if (positions.length == 1) {
      List<Vehicle> vehicles = positions[0]
          .trucks
          .map((e) => Vehicle(
              id: VID(e.truckId),
              position: roadMap[e.roadId]!.positionAt(fraction: e.progress),
              direction: roadMap[e.roadId]!.direction(fraction: e.progress)))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
    }

    // time != generated time т, tomfoolery ensues
    /*


    */
    else {
      double frac =
          (positions[1].time - time) / (positions[1].time - positions[0].time);

      List<Vehicle> vehicles = IterableZip(
              [positions[0].trucks, positions[1].trucks])
          .map((e) => Vehicle(
              id: VID(e[0].truckId),
              position:
                  roadMap[e[_truckRoadChange(e[0], e[1], time, frac) ? 1 : 0].roadId]!
                      .positionAt(
                          fraction: e[0].progress +
                              _truckDistCovered(e[0], e[1], time, frac) % 1.0),
              direction:
                  roadMap[e[_truckRoadChange(e[0], e[1], time, frac) ? 1 : 0].roadId]!
                      .direction(
                          fraction: e[0].progress +
                              _truckDistCovered(e[0], e[1], time, frac))))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
    }
  }
}
