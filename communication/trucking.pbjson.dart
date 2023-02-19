///
//  Generated code. Do not modify.
//  source: trucking.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use timeDeltaDescriptor instead')
const TimeDelta$json = const {
  '1': 'TimeDelta',
  '2': const [
    const {'1': 'seconds', '3': 1, '4': 1, '5': 1, '10': 'seconds'},
  ],
};

/// Descriptor for `TimeDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeDeltaDescriptor = $convert.base64Decode('CglUaW1lRGVsdGESGAoHc2Vjb25kcxgBIAEoAVIHc2Vjb25kcw==');
@$core.Deprecated('Use positionDataStreamDescriptor instead')
const PositionDataStream$json = const {
  '1': 'PositionDataStream',
  '2': const [
    const {'1': 'trucks', '3': 1, '4': 3, '5': 11, '6': '.TruckPositionsAtTime', '10': 'trucks'},
  ],
};

/// Descriptor for `PositionDataStream`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDataStreamDescriptor = $convert.base64Decode('ChJQb3NpdGlvbkRhdGFTdHJlYW0SLQoGdHJ1Y2tzGAEgAygLMhUuVHJ1Y2tQb3NpdGlvbnNBdFRpbWVSBnRydWNrcw==');
@$core.Deprecated('Use truckPositionsAtTimeDescriptor instead')
const TruckPositionsAtTime$json = const {
  '1': 'TruckPositionsAtTime',
  '2': const [
    const {'1': 'trucks', '3': 1, '4': 3, '5': 11, '6': '.Truck', '10': 'trucks'},
    const {'1': 'time', '3': 2, '4': 1, '5': 1, '10': 'time'},
  ],
};

/// Descriptor for `TruckPositionsAtTime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List truckPositionsAtTimeDescriptor = $convert.base64Decode('ChRUcnVja1Bvc2l0aW9uc0F0VGltZRIeCgZ0cnVja3MYASADKAsyBi5UcnVja1IGdHJ1Y2tzEhIKBHRpbWUYAiABKAFSBHRpbWU=');
@$core.Deprecated('Use truckDescriptor instead')
const Truck$json = const {
  '1': 'Truck',
  '2': const [
    const {'1': 'truck_id', '3': 1, '4': 1, '5': 5, '10': 'truckId'},
    const {'1': 'destination_id', '3': 2, '4': 1, '5': 5, '10': 'destinationId'},
    const {'1': 'curr_speed', '3': 3, '4': 1, '5': 1, '10': 'currSpeed'},
    const {'1': 'curr_accel', '3': 4, '4': 1, '5': 1, '10': 'currAccel'},
    const {'1': 'road_id', '3': 5, '4': 1, '5': 5, '10': 'roadId'},
    const {'1': 'progress', '3': 6, '4': 1, '5': 1, '10': 'progress'},
  ],
};

/// Descriptor for `Truck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List truckDescriptor = $convert.base64Decode('CgVUcnVjaxIZCgh0cnVja19pZBgBIAEoBVIHdHJ1Y2tJZBIlCg5kZXN0aW5hdGlvbl9pZBgCIAEoBVINZGVzdGluYXRpb25JZBIdCgpjdXJyX3NwZWVkGAMgASgBUgljdXJyU3BlZWQSHQoKY3Vycl9hY2NlbBgEIAEoAVIJY3VyckFjY2VsEhcKB3JvYWRfaWQYBSABKAVSBnJvYWRJZBIaCghwcm9ncmVzcxgGIAEoAVIIcHJvZ3Jlc3M=');
