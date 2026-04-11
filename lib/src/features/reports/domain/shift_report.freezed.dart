// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShiftReport {

@HiveField(0) String get id;@HiveField(1) String get staffId;@HiveField(2) DateTime get startTime;@HiveField(3) DateTime get endTime;@HiveField(4) double get systemTotal;@HiveField(5) double get declaredCash;@HiveField(6) double get discrepancy;
/// Create a copy of ShiftReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftReportCopyWith<ShiftReport> get copyWith => _$ShiftReportCopyWithImpl<ShiftReport>(this as ShiftReport, _$identity);

  /// Serializes this ShiftReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftReport&&(identical(other.id, id) || other.id == id)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.systemTotal, systemTotal) || other.systemTotal == systemTotal)&&(identical(other.declaredCash, declaredCash) || other.declaredCash == declaredCash)&&(identical(other.discrepancy, discrepancy) || other.discrepancy == discrepancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,staffId,startTime,endTime,systemTotal,declaredCash,discrepancy);

@override
String toString() {
  return 'ShiftReport(id: $id, staffId: $staffId, startTime: $startTime, endTime: $endTime, systemTotal: $systemTotal, declaredCash: $declaredCash, discrepancy: $discrepancy)';
}


}

/// @nodoc
abstract mixin class $ShiftReportCopyWith<$Res>  {
  factory $ShiftReportCopyWith(ShiftReport value, $Res Function(ShiftReport) _then) = _$ShiftReportCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String staffId,@HiveField(2) DateTime startTime,@HiveField(3) DateTime endTime,@HiveField(4) double systemTotal,@HiveField(5) double declaredCash,@HiveField(6) double discrepancy
});




}
/// @nodoc
class _$ShiftReportCopyWithImpl<$Res>
    implements $ShiftReportCopyWith<$Res> {
  _$ShiftReportCopyWithImpl(this._self, this._then);

  final ShiftReport _self;
  final $Res Function(ShiftReport) _then;

/// Create a copy of ShiftReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? staffId = null,Object? startTime = null,Object? endTime = null,Object? systemTotal = null,Object? declaredCash = null,Object? discrepancy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,systemTotal: null == systemTotal ? _self.systemTotal : systemTotal // ignore: cast_nullable_to_non_nullable
as double,declaredCash: null == declaredCash ? _self.declaredCash : declaredCash // ignore: cast_nullable_to_non_nullable
as double,discrepancy: null == discrepancy ? _self.discrepancy : discrepancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftReport].
extension ShiftReportPatterns on ShiftReport {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftReport() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftReport value)  $default,){
final _that = this;
switch (_that) {
case _ShiftReport():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftReport value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftReport() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String staffId, @HiveField(2)  DateTime startTime, @HiveField(3)  DateTime endTime, @HiveField(4)  double systemTotal, @HiveField(5)  double declaredCash, @HiveField(6)  double discrepancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftReport() when $default != null:
return $default(_that.id,_that.staffId,_that.startTime,_that.endTime,_that.systemTotal,_that.declaredCash,_that.discrepancy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String staffId, @HiveField(2)  DateTime startTime, @HiveField(3)  DateTime endTime, @HiveField(4)  double systemTotal, @HiveField(5)  double declaredCash, @HiveField(6)  double discrepancy)  $default,) {final _that = this;
switch (_that) {
case _ShiftReport():
return $default(_that.id,_that.staffId,_that.startTime,_that.endTime,_that.systemTotal,_that.declaredCash,_that.discrepancy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String staffId, @HiveField(2)  DateTime startTime, @HiveField(3)  DateTime endTime, @HiveField(4)  double systemTotal, @HiveField(5)  double declaredCash, @HiveField(6)  double discrepancy)?  $default,) {final _that = this;
switch (_that) {
case _ShiftReport() when $default != null:
return $default(_that.id,_that.staffId,_that.startTime,_that.endTime,_that.systemTotal,_that.declaredCash,_that.discrepancy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 5, adapterName: 'ShiftReportAdapter')
class _ShiftReport implements ShiftReport {
  const _ShiftReport({@HiveField(0) required this.id, @HiveField(1) required this.staffId, @HiveField(2) required this.startTime, @HiveField(3) required this.endTime, @HiveField(4) required this.systemTotal, @HiveField(5) required this.declaredCash, @HiveField(6) required this.discrepancy});
  factory _ShiftReport.fromJson(Map<String, dynamic> json) => _$ShiftReportFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String staffId;
@override@HiveField(2) final  DateTime startTime;
@override@HiveField(3) final  DateTime endTime;
@override@HiveField(4) final  double systemTotal;
@override@HiveField(5) final  double declaredCash;
@override@HiveField(6) final  double discrepancy;

/// Create a copy of ShiftReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftReportCopyWith<_ShiftReport> get copyWith => __$ShiftReportCopyWithImpl<_ShiftReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShiftReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftReport&&(identical(other.id, id) || other.id == id)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.systemTotal, systemTotal) || other.systemTotal == systemTotal)&&(identical(other.declaredCash, declaredCash) || other.declaredCash == declaredCash)&&(identical(other.discrepancy, discrepancy) || other.discrepancy == discrepancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,staffId,startTime,endTime,systemTotal,declaredCash,discrepancy);

@override
String toString() {
  return 'ShiftReport(id: $id, staffId: $staffId, startTime: $startTime, endTime: $endTime, systemTotal: $systemTotal, declaredCash: $declaredCash, discrepancy: $discrepancy)';
}


}

/// @nodoc
abstract mixin class _$ShiftReportCopyWith<$Res> implements $ShiftReportCopyWith<$Res> {
  factory _$ShiftReportCopyWith(_ShiftReport value, $Res Function(_ShiftReport) _then) = __$ShiftReportCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String staffId,@HiveField(2) DateTime startTime,@HiveField(3) DateTime endTime,@HiveField(4) double systemTotal,@HiveField(5) double declaredCash,@HiveField(6) double discrepancy
});




}
/// @nodoc
class __$ShiftReportCopyWithImpl<$Res>
    implements _$ShiftReportCopyWith<$Res> {
  __$ShiftReportCopyWithImpl(this._self, this._then);

  final _ShiftReport _self;
  final $Res Function(_ShiftReport) _then;

/// Create a copy of ShiftReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? staffId = null,Object? startTime = null,Object? endTime = null,Object? systemTotal = null,Object? declaredCash = null,Object? discrepancy = null,}) {
  return _then(_ShiftReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,systemTotal: null == systemTotal ? _self.systemTotal : systemTotal // ignore: cast_nullable_to_non_nullable
as double,declaredCash: null == declaredCash ? _self.declaredCash : declaredCash // ignore: cast_nullable_to_non_nullable
as double,discrepancy: null == discrepancy ? _self.discrepancy : discrepancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
