///
//  Generated code. Do not modify.
//  source: trucking.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ConfigAsString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConfigAsString', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'json')
    ..hasRequiredFields = false
  ;

  ConfigAsString._() : super();
  factory ConfigAsString({
    $core.String? json,
  }) {
    final _result = create();
    if (json != null) {
      _result.json = json;
    }
    return _result;
  }
  factory ConfigAsString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConfigAsString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConfigAsString clone() => ConfigAsString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConfigAsString copyWith(void Function(ConfigAsString) updates) => super.copyWith((message) => updates(message as ConfigAsString)) as ConfigAsString; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigAsString create() => ConfigAsString._();
  ConfigAsString createEmptyInstance() => create();
  static $pb.PbList<ConfigAsString> createRepeated() => $pb.PbList<ConfigAsString>();
  @$core.pragma('dart2js:noInline')
  static ConfigAsString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConfigAsString>(create);
  static ConfigAsString? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get json => $_getSZ(0);
  @$pb.TagNumber(1)
  set json($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearJson() => clearField(1);
}

class TimeDelta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimeDelta', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seconds', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  TimeDelta._() : super();
  factory TimeDelta({
    $core.double? seconds,
  }) {
    final _result = create();
    if (seconds != null) {
      _result.seconds = seconds;
    }
    return _result;
  }
  factory TimeDelta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeDelta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeDelta clone() => TimeDelta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeDelta copyWith(void Function(TimeDelta) updates) => super.copyWith((message) => updates(message as TimeDelta)) as TimeDelta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimeDelta create() => TimeDelta._();
  TimeDelta createEmptyInstance() => create();
  static $pb.PbList<TimeDelta> createRepeated() => $pb.PbList<TimeDelta>();
  @$core.pragma('dart2js:noInline')
  static TimeDelta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeDelta>(create);
  static TimeDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get seconds => $_getN(0);
  @$pb.TagNumber(1)
  set seconds($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeconds() => clearField(1);
}

class PositionDataStream extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PositionDataStream', createEmptyInstance: create)
    ..pc<TruckPositionsAtTime>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trucks', $pb.PbFieldType.PM, subBuilder: TruckPositionsAtTime.create)
    ..hasRequiredFields = false
  ;

  PositionDataStream._() : super();
  factory PositionDataStream({
    $core.Iterable<TruckPositionsAtTime>? trucks,
  }) {
    final _result = create();
    if (trucks != null) {
      _result.trucks.addAll(trucks);
    }
    return _result;
  }
  factory PositionDataStream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PositionDataStream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PositionDataStream clone() => PositionDataStream()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PositionDataStream copyWith(void Function(PositionDataStream) updates) => super.copyWith((message) => updates(message as PositionDataStream)) as PositionDataStream; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PositionDataStream create() => PositionDataStream._();
  PositionDataStream createEmptyInstance() => create();
  static $pb.PbList<PositionDataStream> createRepeated() => $pb.PbList<PositionDataStream>();
  @$core.pragma('dart2js:noInline')
  static PositionDataStream getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PositionDataStream>(create);
  static PositionDataStream? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TruckPositionsAtTime> get trucks => $_getList(0);
}

class TruckPositionsAtTime extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TruckPositionsAtTime', createEmptyInstance: create)
    ..pc<Truck>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trucks', $pb.PbFieldType.PM, subBuilder: Truck.create)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  TruckPositionsAtTime._() : super();
  factory TruckPositionsAtTime({
    $core.Iterable<Truck>? trucks,
    $core.double? time,
  }) {
    final _result = create();
    if (trucks != null) {
      _result.trucks.addAll(trucks);
    }
    if (time != null) {
      _result.time = time;
    }
    return _result;
  }
  factory TruckPositionsAtTime.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TruckPositionsAtTime.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TruckPositionsAtTime clone() => TruckPositionsAtTime()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TruckPositionsAtTime copyWith(void Function(TruckPositionsAtTime) updates) => super.copyWith((message) => updates(message as TruckPositionsAtTime)) as TruckPositionsAtTime; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TruckPositionsAtTime create() => TruckPositionsAtTime._();
  TruckPositionsAtTime createEmptyInstance() => create();
  static $pb.PbList<TruckPositionsAtTime> createRepeated() => $pb.PbList<TruckPositionsAtTime>();
  @$core.pragma('dart2js:noInline')
  static TruckPositionsAtTime getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TruckPositionsAtTime>(create);
  static TruckPositionsAtTime? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Truck> get trucks => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get time => $_getN(1);
  @$pb.TagNumber(2)
  set time($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
}

class Truck extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Truck', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'truckId', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destinationId', $pb.PbFieldType.O3)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currSpeed', $pb.PbFieldType.OD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currAccel', $pb.PbFieldType.OD)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roadId', $pb.PbFieldType.O3)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', $pb.PbFieldType.OD)
    ..pc<PathElement>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path', $pb.PbFieldType.PM, subBuilder: PathElement.create)
    ..hasRequiredFields = false
  ;

  Truck._() : super();
  factory Truck({
    $core.int? truckId,
    $core.int? destinationId,
    $core.double? currSpeed,
    $core.double? currAccel,
    $core.int? roadId,
    $core.double? progress,
    $core.Iterable<PathElement>? path,
  }) {
    final _result = create();
    if (truckId != null) {
      _result.truckId = truckId;
    }
    if (destinationId != null) {
      _result.destinationId = destinationId;
    }
    if (currSpeed != null) {
      _result.currSpeed = currSpeed;
    }
    if (currAccel != null) {
      _result.currAccel = currAccel;
    }
    if (roadId != null) {
      _result.roadId = roadId;
    }
    if (progress != null) {
      _result.progress = progress;
    }
    if (path != null) {
      _result.path.addAll(path);
    }
    return _result;
  }
  factory Truck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Truck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Truck clone() => Truck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Truck copyWith(void Function(Truck) updates) => super.copyWith((message) => updates(message as Truck)) as Truck; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Truck create() => Truck._();
  Truck createEmptyInstance() => create();
  static $pb.PbList<Truck> createRepeated() => $pb.PbList<Truck>();
  @$core.pragma('dart2js:noInline')
  static Truck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Truck>(create);
  static Truck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get truckId => $_getIZ(0);
  @$pb.TagNumber(1)
  set truckId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTruckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTruckId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get destinationId => $_getIZ(1);
  @$pb.TagNumber(2)
  set destinationId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestinationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestinationId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get currSpeed => $_getN(2);
  @$pb.TagNumber(3)
  set currSpeed($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrSpeed() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrSpeed() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get currAccel => $_getN(3);
  @$pb.TagNumber(4)
  set currAccel($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrAccel() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrAccel() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get roadId => $_getIZ(4);
  @$pb.TagNumber(5)
  set roadId($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRoadId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoadId() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get progress => $_getN(5);
  @$pb.TagNumber(6)
  set progress($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearProgress() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<PathElement> get path => $_getList(6);
}

enum PathElement_NodeOrRoad {
  nodeId, 
  roadId, 
  notSet
}

class PathElement extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, PathElement_NodeOrRoad> _PathElement_NodeOrRoadByTag = {
    1 : PathElement_NodeOrRoad.nodeId,
    2 : PathElement_NodeOrRoad.roadId,
    0 : PathElement_NodeOrRoad.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PathElement', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeId', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roadId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  PathElement._() : super();
  factory PathElement({
    $core.int? nodeId,
    $core.int? roadId,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (roadId != null) {
      _result.roadId = roadId;
    }
    return _result;
  }
  factory PathElement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathElement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PathElement clone() => PathElement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathElement copyWith(void Function(PathElement) updates) => super.copyWith((message) => updates(message as PathElement)) as PathElement; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PathElement create() => PathElement._();
  PathElement createEmptyInstance() => create();
  static $pb.PbList<PathElement> createRepeated() => $pb.PbList<PathElement>();
  @$core.pragma('dart2js:noInline')
  static PathElement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathElement>(create);
  static PathElement? _defaultInstance;

  PathElement_NodeOrRoad whichNodeOrRoad() => _PathElement_NodeOrRoadByTag[$_whichOneof(0)]!;
  void clearNodeOrRoad() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get nodeId => $_getIZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get roadId => $_getIZ(1);
  @$pb.TagNumber(2)
  set roadId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoadId() => clearField(2);
}

class Void extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Void', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Void._() : super();
  factory Void() => create();
  factory Void.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Void.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Void clone() => Void()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Void copyWith(void Function(Void) updates) => super.copyWith((message) => updates(message as Void)) as Void; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Void create() => Void._();
  Void createEmptyInstance() => create();
  static $pb.PbList<Void> createRepeated() => $pb.PbList<Void>();
  @$core.pragma('dart2js:noInline')
  static Void getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Void>(create);
  static Void? _defaultInstance;
}

