import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/shift_report.dart';

part 'shift_report_repository.g.dart';

@Riverpod(keepAlive: true)
class ShiftReportRepository extends _$ShiftReportRepository {
  late final Box<ShiftReport> _box;

  @override
  List<ShiftReport> build() {
    _box = Hive.box<ShiftReport>('shift_reports');
    return _box.values.toList();
  }

  Future<void> saveReport(ShiftReport report) async {
    await _box.put(report.id, report);
    state = _box.values.toList();
  }

  List<ShiftReport> getByStaff(String staffId) {
    return _box.values.where((r) => r.staffId == staffId).toList();
  }

  List<ShiftReport> getByDateRange(DateTime start, DateTime end) {
    return _box.values.where((r) {
      return r.endTime.isAfter(start) && r.endTime.isBefore(end);
    }).toList();
  }
}
