# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: trucking.proto
"""Generated protocol buffer code."""
from google.protobuf.internal import builder as _builder
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x0etrucking.proto\"\x1c\n\tTimeDelta\x12\x0f\n\x07seconds\x18\x01 \x01(\x01\";\n\x12PositionDataStream\x12%\n\x06trucks\x18\x01 \x03(\x0b\x32\x15.TruckPositionsAtTime\"<\n\x14TruckPositionsAtTime\x12\x16\n\x06trucks\x18\x01 \x03(\x0b\x32\x06.Truck\x12\x0c\n\x04time\x18\x02 \x01(\x01\"\x98\x01\n\x05Truck\x12\x10\n\x08truck_id\x18\x01 \x01(\x05\x12\x16\n\x0e\x64\x65stination_id\x18\x02 \x01(\x05\x12\x12\n\ncurr_speed\x18\x03 \x01(\x01\x12\x12\n\ncurr_accel\x18\x04 \x01(\x01\x12\x0f\n\x07road_id\x18\x05 \x01(\x05\x12\x10\n\x08progress\x18\x06 \x01(\x01\x12\x1a\n\x04path\x18\x07 \x03(\x0b\x32\x0c.PathElement\"A\n\x0bPathElement\x12\x11\n\x07node_id\x18\x01 \x01(\x05H\x00\x12\x11\n\x07road_id\x18\x02 \x01(\x05H\x00\x42\x0c\n\nNodeOrRoad2J\n\x14PositionDataStreamer\x12\x32\n\x0fgetPositionData\x12\n.TimeDelta\x1a\x13.PositionDataStreamb\x06proto3')

_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, globals())
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'trucking_pb2', globals())
if _descriptor._USE_C_DESCRIPTORS == False:

  DESCRIPTOR._options = None
  _TIMEDELTA._serialized_start=18
  _TIMEDELTA._serialized_end=46
  _POSITIONDATASTREAM._serialized_start=48
  _POSITIONDATASTREAM._serialized_end=107
  _TRUCKPOSITIONSATTIME._serialized_start=109
  _TRUCKPOSITIONSATTIME._serialized_end=169
  _TRUCK._serialized_start=172
  _TRUCK._serialized_end=324
  _PATHELEMENT._serialized_start=326
  _PATHELEMENT._serialized_end=391
  _POSITIONDATASTREAMER._serialized_start=393
  _POSITIONDATASTREAMER._serialized_end=467
# @@protoc_insertion_point(module_scope)
