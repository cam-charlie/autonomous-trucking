import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:frontend/constants.dart' as constants;

/// Vehicle ID
class VID extends Equatable {
  const VID(int id) : _id = id;
  final int _id;

  @override
  List<Object> get props => [_id];
}

class Vehicle {
  final double x;
  final double y;
  final double direction; // radians
  final VID id;

  Color get colour =>
      constants.vehicleColours[id.hashCode % constants.vehicleColours.length];

  const Vehicle(
      {required this.id, required this.x, required this.y, required this.direction});
}