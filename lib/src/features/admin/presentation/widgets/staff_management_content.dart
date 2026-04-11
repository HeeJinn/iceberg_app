import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../auth/data/staff_repository.dart';
import '../../../auth/domain/staff_member.dart';

class StaffManagementContent extends ConsumerStatefulWidget {
  const StaffManagementContent({super.key});

  @override
  ConsumerState<StaffManagementContent> createState() =>
      _StaffManagementContentState();
}

class _StaffManagementContentState
    extends ConsumerState<StaffManagementContent> {
  @override
  Widget build(BuildContext context) {
    final staffList = ref.watch(staffRepositoryProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Row(
            children: [
              Expanded(
                child: Text('Staff Management',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              ElevatedButton.icon(
                onPressed: () => _showStaffForm(context, ref),
                icon: const Icon(Icons.person_add),
                label: Text(isMobile ? 'Add' : 'Add Staff'),
              ),
            ],
          ),
        ),
        Expanded(
          child: staffList.isEmpty
              ? const Center(child: Text('No staff added'))
              : ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  itemCount: staffList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: staff.isAdmin
                            ? IcebergTheme.vibrantRosePink.withValues(alpha: 0.15)
                            : IcebergTheme.mintBlue.withValues(alpha: 0.5),
                        child: Icon(
                          staff.isAdmin
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: staff.isAdmin
                              ? IcebergTheme.vibrantRosePink
                              : IcebergTheme.darkSlate,
                        ),
                      ),
                      title: Text(staff.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: staff.isActive
                                ? null
                                : TextDecoration.lineThrough,
                          )),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: staff.isAdmin
                                  ? IcebergTheme.creamPink
                                  : IcebergTheme.mintBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              staff.isAdmin ? 'Admin' : 'Cashier',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('PIN: ••••',
                              style:
                                  TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: staff.isActive,
                            onChanged: (_) =>
                                ref.read(staffRepositoryProvider.notifier)
                                    .toggleActive(staff.id),
                            activeTrackColor: IcebergTheme.vibrantRosePink,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () =>
                                _showStaffForm(context, ref, staff: staff),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showStaffForm(BuildContext context, WidgetRef ref,
      {StaffMember? staff}) {
    final nameCtrl = TextEditingController(text: staff?.name ?? '');
    final pinCtrl = TextEditingController(text: staff?.pin ?? '');
    var role = staff?.role ?? StaffRole.cashier;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            title: Text(staff == null ? 'Add Staff' : 'Edit Staff'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pinCtrl,
                  decoration: const InputDecoration(
                    labelText: '4-Digit PIN',
                    prefixIcon: Icon(Icons.pin),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<StaffRole>(
                  value: role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  items: StaffRole.values
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                                r == StaffRole.admin ? 'Admin' : 'Cashier'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => role = v);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty || pinCtrl.text.length != 4) {
                    return;
                  }
                  final newStaff = StaffMember(
                    id: staff?.id ?? const Uuid().v4(),
                    name: nameCtrl.text.trim(),
                    pin: pinCtrl.text,
                    role: role,
                    isActive: staff?.isActive ?? true,
                  );
                  if (staff == null) {
                    ref
                        .read(staffRepositoryProvider.notifier)
                        .addStaff(newStaff);
                  } else {
                    ref
                        .read(staffRepositoryProvider.notifier)
                        .updateStaff(newStaff);
                  }
                  Navigator.pop(context);
                },
                child: Text(staff == null ? 'Add' : 'Update'),
              ),
            ],
          );
        },
      ),
    );
  }
}
