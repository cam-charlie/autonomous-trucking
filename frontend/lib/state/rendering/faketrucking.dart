class Truck {
  int truckId;
  int destinationId;
  double currSpeed;
  double currAccel;
  int roadId;
  double progress;

  Truck(
      {required this.truckId,
      required this.destinationId,
      required this.currSpeed,
      required this.currAccel,
      required this.roadId,
      required this.progress});
}

class TruckPositionsAtTime {
  Iterable<Truck> trucks;
  double time;
  TruckPositionsAtTime({required this.trucks, required this.time});
}

Future<List<TruckPositionsAtTime>> getPositionData(double t) async {
  return [TruckPositionsAtTime(trucks: [], time: 0.0)];
}
