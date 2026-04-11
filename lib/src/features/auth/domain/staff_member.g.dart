// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StaffMemberAdapter extends TypeAdapter<StaffMember> {
  @override
  final typeId = 7;

  @override
  StaffMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StaffMember(
      id: fields[0] as String,
      name: fields[1] as String,
      pin: fields[2] as String,
      role: fields[3] as StaffRole,
      isActive: fields[4] == null ? true : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StaffMember obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pin)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StaffRoleAdapter extends TypeAdapter<StaffRole> {
  @override
  final typeId = 6;

  @override
  StaffRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StaffRole.admin;
      case 1:
        return StaffRole.cashier;
      default:
        return StaffRole.admin;
    }
  }

  @override
  void write(BinaryWriter writer, StaffRole obj) {
    switch (obj) {
      case StaffRole.admin:
        writer.writeByte(0);
      case StaffRole.cashier:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
