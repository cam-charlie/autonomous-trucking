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

class Vehicle with EquatableMixin {
  final Offset position;
  final double direction; // radians
  final VID id;

  Color get colour =>
      constants.vehicleColours[id.hashCode % constants.vehicleColours.length];

  const Vehicle(
      {required this.id, required this.position, required this.direction});

  @override
  List<Object> get props => [position, direction, id];
}