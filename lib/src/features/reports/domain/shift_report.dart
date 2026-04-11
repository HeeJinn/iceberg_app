import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'shift_report.freezed.dart';
part 'shift_report.g.dart';

@freezed
abstract class ShiftReport with _$ShiftReport {
  // ignore: invalid_annotation_target
  @HiveType(typeId: 5, adapterName: 'ShiftReportAdapter')
  const factory ShiftReport({
    @HiveField(0) required String id,
    @HiveField(1) required String staffId,
    @HiveField(2) required DateTime startTime,
    @HiveField(3) required DateTime endTime,
    @HiveField(4) required double systemTotal,
    @HiveField(5) required double declaredCash,
    @HiveField(6) required double discrepancy,
  }) = _ShiftReport;

  factory ShiftReport.fromJson(Map<String, dynamic> json) => _$ShiftReportFromJson(json);
}
