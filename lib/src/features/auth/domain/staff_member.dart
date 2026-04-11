import 'package:hive_ce/hive.dart';

part 'staff_member.g.dart';

@HiveType(typeId: 6)
enum StaffRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  cashier,
}

@HiveType(typeId: 7, adapterName: 'StaffMemberAdapter')
class StaffMember extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String pin;

  @HiveField(3)
  final StaffRole role;

  @HiveField(4)
  final bool isActive;

  StaffMember({
    required this.id,
    required this.name,
    required this.pin,
    required this.role,
    this.isActive = true,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    String? pin,
    StaffRole? role,
    bool? isActive,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isAdmin => role == StaffRole.admin;
}
