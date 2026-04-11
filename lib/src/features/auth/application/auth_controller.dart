import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/staff_member.dart';
import '../data/staff_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  StaffMember? build() {
    // Returns the StaffMember if logged in. Null means nobody is logged in.
    return null;
  }

  Future<bool> loginWithPin(String pin) async {
    // Simulated database delay
    await Future.delayed(const Duration(milliseconds: 300));

    final staffRepo = ref.read(staffRepositoryProvider.notifier);
    final staff = staffRepo.findByPin(pin);

    if (staff != null) {
      state = staff;
      return true;
    }

    return false;
  }

  void logout() {
    state = null;
  }

  bool get isAdmin => state?.isAdmin ?? false;
  String get staffName => state?.name ?? 'Unknown';
  String get staffId => state?.id ?? '';
}
