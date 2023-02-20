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
  double _truckFracDistCovered(
      Truck start, Truck end, double t0, double ti, Map<RID, RenderRoad> map) {
    double juncDist = start.roadId == end.roadId
        ? double.infinity
        : (1 - start.progress) * map[start.roadId]!.length;
    double interDist = (start.currSpeed + end.currSpeed) / 2 + (ti - t0);
    double fracDist = interDist < juncDist
        ? interDist / map[start.roadId]!.length
        : 1 - start.progress + (interDist - juncDist) / map[end.roadId]!.length;

    return fracDist;
  }

  // Determine if truck has switched between raod A and road B

  bool _truckRoadChange(
      Truck start, Truck end, double t0, double ti, Map<RID, RenderRoad> map) {
    return start.progress + _truckFracDistCovered(start, end, t0, ti, map) > 1;
  }

  // Generates new SimulationState for rendering
  Future<SimulationState> getState({double time = 0.0}) async {
    // TODO: Dart refuses to allow constant maps, any ideas to fix this would be appreciated

    Map<RID, RenderRoad> roadMap =
        Map.fromIterable(roads.map((e) => {e.id: e}));

    List<TruckPositionsAtTime> positions = await getPositionData(time);

    // time == generated time t0, state matches generation

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

    // time != generated time t0, tomfoolery ensues
    /*


    */
    else {
      List<Vehicle> vehicles = IterableZip([positions[0].trucks, positions[1].trucks])
          .map((e) => Vehicle(
              id: VID(e[0].truckId),
              position: roadMap[e[_truckRoadChange(e[0], e[1], time, positions[0].time, roadMap) ? 1 : 0].roadId]!.positionAt(
                  fraction: (e[0].progress +
                          _truckFracDistCovered(
                              e[0], e[1], time, positions[0].time, roadMap)) %
                      1.0),
              direction: roadMap[e[_truckRoadChange(e[0], e[1], time, positions[0].time, roadMap) ? 1 : 0].roadId]!
                  .direction(
                      fraction: e[0].progress +
                          _truckFracDistCovered(e[0], e[1], time, positions[0].time, roadMap))))
          .toList();
      return SimulationState(vehicles: vehicles, roads: roads);
    }
  }
}
