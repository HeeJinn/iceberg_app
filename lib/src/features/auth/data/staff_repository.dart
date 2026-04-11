import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/staff_member.dart';

part 'staff_repository.g.dart';

@riverpod
class StaffRepository extends _$StaffRepository {
  late final Box<StaffMember> _box;

  @override
  List<StaffMember> build() {
    _box = Hive.box<StaffMember>('staff');

    if (_box.isEmpty) {
      final defaults = [
        StaffMember(
          id: 'staff_001',
          name: 'Manager Jane',
          pin: '1234',
          role: StaffRole.admin,
        ),
        StaffMember(
          id: 'staff_002',
          name: 'Cashier John',
          pin: '5678',
          role: StaffRole.cashier,
        ),
      ];
      for (var s in defaults) {
        _box.put(s.id, s);
      }
    }
    return _box.values.toList();
  }

  StaffMember? findByPin(String pin) {
    try {
      return _box.values.firstWhere(
        (s) => s.pin == pin && s.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  void addStaff(StaffMember staff) {
    _box.put(staff.id, staff);
    state = _box.values.toList();
  }

  void updateStaff(StaffMember staff) {
    _box.put(staff.id, staff);
    state = _box.values.toList();
  }

  void deleteStaff(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }

  void toggleActive(String id) {
    final staff = _box.get(id);
    if (staff != null) {
      final updated = staff.copyWith(isActive: !staff.isActive);
      _box.put(id, updated);
      state = _box.values.toList();
    }
  }
}
