// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftReportAdapter extends TypeAdapter<_ShiftReport> {
  @override
  final typeId = 5;

  @override
  _ShiftReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _ShiftReport(
      id: fields[0] as String,
      staffId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      systemTotal: (fields[4] as num).toDouble(),
      declaredCash: (fields[5] as num).toDouble(),
      discrepancy: (fields[6] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, _ShiftReport obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.staffId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.systemTotal)
      ..writeByte(5)
      ..write(obj.declaredCash)
      ..writeByte(6)
      ..write(obj.discrepancy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShiftReport _$ShiftReportFromJson(Map<String, dynamic> json) => _ShiftReport(
  id: json['id'] as String,
  staffId: json['staffId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  systemTotal: (json['systemTotal'] as num).toDouble(),
  declaredCash: (json['declaredCash'] as num).toDouble(),
  discrepancy: (json['discrepancy'] as num).toDouble(),
);

Map<String, dynamic> _$ShiftReportToJson(_ShiftReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'staffId': instance.staffId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'systemTotal': instance.systemTotal,
      'declaredCash': instance.declaredCash,
      'discrepancy': instance.discrepancy,
    };
