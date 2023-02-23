///
//  Generated code. Do not modify.
//  source: trucking.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'trucking.pb.dart' as $0;
export 'trucking.pb.dart';

class PositionDataStreamerClient extends $grpc.Client {
  static final _$getPositionData =
      $grpc.ClientMethod<$0.TimeDelta, $0.PositionDataStream>(
          '/PositionDataStreamer/getPositionData',
          ($0.TimeDelta value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.PositionDataStream.fromBuffer(value));

  PositionDataStreamerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.PositionDataStream> getPositionData(
      $0.TimeDelta request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPositionData, request, options: options);
  }
}

abstract class PositionDataStreamerServiceBase extends $grpc.Service {
  $core.String get $name => 'PositionDataStreamer';

  PositionDataStreamerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TimeDelta, $0.PositionDataStream>(
        'getPositionData',
        getPositionData_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TimeDelta.fromBuffer(value),
        ($0.PositionDataStream value) => value.writeToBuffer()));
  }

  $async.Future<$0.PositionDataStream> getPositionData_Pre(
      $grpc.ServiceCall call, $async.Future<$0.TimeDelta> request) async {
    return getPositionData(call, await request);
  }

  $async.Future<$0.PositionDataStream> getPositionData(
      $grpc.ServiceCall call, $0.TimeDelta request);
}
