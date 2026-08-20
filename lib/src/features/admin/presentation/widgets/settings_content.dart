import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../products/data/modifier_options_repository.dart';

class SettingsContent extends ConsumerStatefulWidget {
  const SettingsContent({super.key});

  @override
  ConsumerState<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends ConsumerState<SettingsContent> {
  late final Box _settingsBox;
  late final TextEditingController _storeNameCtrl;
  late final TextEditingController _taxRateCtrl;
  late final TextEditingController _receiptHeaderCtrl;
  late final TextEditingController _receiptFooterCtrl;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settings');
    _storeNameCtrl = TextEditingController(
        text: _settingsBox.get('storeName', defaultValue: 'Iceberg Ice Cream'));
    _taxRateCtrl = TextEditingController(
        text: _settingsBox.get('taxRate', defaultValue: '0.0'));
    _receiptHeaderCtrl = TextEditingController(
        text: _settingsBox.get('receiptHeader',
            defaultValue: 'Welcome to Iceberg!'));
    _receiptFooterCtrl = TextEditingController(
        text: _settingsBox.get('receiptFooter',
            defaultValue: 'Thank you! Come again!'));
  }

  @override
  void dispose() {
    _storeNameCtrl.dispose();
    _taxRateCtrl.dispose();
    _receiptHeaderCtrl.dispose();
    _receiptFooterCtrl.dispose();
    super.dispose();
  }

  void _save() {
    _settingsBox.put('storeName', _storeNameCtrl.text);
    _settingsBox.put('taxRate', _taxRateCtrl.text);
    _settingsBox.put('receiptHeader', _receiptHeaderCtrl.text);
    _settingsBox.put('receiptFooter', _receiptFooterCtrl.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Settings saved successfully'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vessels = ref.watch(vesselOptionsRepositoryProvider);
    final flavors = ref.watch(flavorOptionsRepositoryProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    final padding = isMobile ? 16.0 : 28.0;

    return Column(
      children: [
        // Fixed header
        Container(
          padding: EdgeInsets.fromLTRB(padding, isMobile ? 16 : 24, padding, 16),
          decoration: BoxDecoration(
            color: IcebergTheme.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configure your store preferences',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(isMobile ? 'Save' : 'Save Changes'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Store Information ──────────────────────────
                _SectionHeader(
                  icon: Icons.storefront_rounded,
                  iconColor: IcebergTheme.vibrantRosePink,
                  iconBg: IcebergTheme.creamPink.withValues(alpha: 0.6),
                  title: 'Store Information',
                  subtitle: 'Basic store details and tax configuration',
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  children: [
                    _SettingsField(
                      label: 'Store Name',
                      icon: Icons.store_rounded,
                      child: TextField(
                        controller: _storeNameCtrl,
                        decoration: _inputDecoration(
                          hint: 'Enter store name',
                        ),
                      ),
                    ),
                    const _SettingsDivider(),
                    _SettingsField(
                      label: 'Tax Rate',
                      icon: Icons.percent_rounded,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: IcebergTheme.mintBlue.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_taxRateCtrl.text}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: IcebergTheme.darkSlate,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _taxRateCtrl,
                        decoration: _inputDecoration(
                          hint: '0.0',
                          helperText: 'Set to 0 if no tax applies',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Receipt Settings ────────────────────────────
                _SectionHeader(
                  icon: Icons.receipt_long_rounded,
                  iconColor: const Color(0xFF5C6BC0),
                  iconBg: const Color(0xFF5C6BC0).withValues(alpha: 0.12),
                  title: 'Receipt Customization',
                  subtitle: 'Personalize what appears on printed receipts',
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  children: [
                    _SettingsField(
                      label: 'Header Message',
                      icon: Icons.article_rounded,
                      child: TextField(
                        controller: _receiptHeaderCtrl,
                        decoration: _inputDecoration(
                          hint: 'Welcome to Iceberg!',
                          helperText: 'Shown at the top of every receipt',
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const _SettingsDivider(),
                    _SettingsField(
                      label: 'Footer Message',
                      icon: Icons.speaker_notes_rounded,
                      child: TextField(
                        controller: _receiptFooterCtrl,
                        decoration: _inputDecoration(
                          hint: 'Thank you! Come again!',
                          helperText: 'Shown at the bottom of every receipt',
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Vessel Options ──────────────────────────────
                _SectionHeader(
                  icon: Icons.coffee_rounded,
                  iconColor: const Color(0xFFE65100),
                  iconBg: const Color(0xFFFFE0B2),
                  title: 'Vessel Options',
                  subtitle:
                      'Manage vessel choices (Cup, Cone, etc.) shown at ordering',
                  action: _AddButton(
                    onTap: () => _showAddModifierDialog(
                      context,
                      title: 'Add Vessel',
                      onSave: (option) {
                        ref
                            .read(vesselOptionsRepositoryProvider.notifier)
                            .add(option);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (vessels.isEmpty)
                  _EmptyModifierCard(
                    icon: Icons.coffee_rounded,
                    label: 'No vessel options configured',
                  )
                else
                  _SettingsCard(
                    children: _buildModifierRows(vessels, isVessel: true),
                  ),
                const SizedBox(height: 28),

                // ── Flavor Options ──────────────────────────────
                _SectionHeader(
                  icon: Icons.icecream_rounded,
                  iconColor: IcebergTheme.vibrantRosePink,
                  iconBg: IcebergTheme.creamPink.withValues(alpha: 0.6),
                  title: 'Flavor Options',
                  subtitle:
                      'Manage scoop flavors available for ice cream orders',
                  action: _AddButton(
                    onTap: () => _showAddModifierDialog(
                      context,
                      title: 'Add Flavor',
                      onSave: (option) {
                        ref
                            .read(flavorOptionsRepositoryProvider.notifier)
                            .add(option);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (flavors.isEmpty)
                  _EmptyModifierCard(
                    icon: Icons.icecream_rounded,
                    label: 'No flavor options configured',
                  )
                else
                  _SettingsCard(
                    children: _buildModifierRows(flavors, isVessel: false),
                  ),
                const SizedBox(height: 28),

                // ── About ───────────────────────────────────────
                _SectionHeader(
                  icon: Icons.info_rounded,
                  iconColor: const Color(0xFF4FC3F7),
                  iconBg: const Color(0xFF4FC3F7).withValues(alpha: 0.12),
                  title: 'About',
                  subtitle: 'Application information',
                ),
                const SizedBox(height: 14),
                _SettingsCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  IcebergTheme.vibrantRosePink,
                                  IcebergTheme.vibrantRosePink
                                      .withValues(alpha: 0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.icecream_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Iceberg POS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Version 1.0.0 · Offline-first POS',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Stable',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Builds modifier rows with interleaved dividers ──
  List<Widget> _buildModifierRows(List<ModifierOption> items,
      {required bool isVessel}) {
    final list = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) list.add(const _SettingsDivider());
      list.add(_buildModifierTile(items[i], isVessel: isVessel));
    }
    return list;
  }

  Widget _buildModifierTile(ModifierOption item, {required bool isVessel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isVessel
                  ? const Color(0xFFFFE0B2)
                  : IcebergTheme.creamPink.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isVessel ? Icons.coffee_rounded : Icons.icecream_rounded,
              size: 18,
              color: isVessel
                  ? const Color(0xFFE65100)
                  : IcebergTheme.vibrantRosePink,
            ),
          ),
          const SizedBox(width: 14),
          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.price > 0
                      ? '+\u20B1${item.price.toStringAsFixed(2)}'
                      : 'Included',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.price > 0
                        ? IcebergTheme.vibrantRosePink
                        : Colors.grey.shade500,
                    fontWeight:
                        item.price > 0 ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => _showEditModifierDialog(
              context,
              title: isVessel ? 'Edit Vessel' : 'Edit Flavor',
              option: item,
              onSave: (updated) {
                if (isVessel) {
                  ref.read(vesselOptionsRepositoryProvider.notifier).update(item.name, updated);
                } else {
                  ref.read(flavorOptionsRepositoryProvider.notifier).update(item.name, updated);
                }
              },
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              minimumSize: const Size(34, 34),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18,
                color: Colors.red.shade400),
            onPressed: () => _confirmDeleteModifier(
              item,
              (option) {
                if (isVessel) {
                  ref.read(vesselOptionsRepositoryProvider.notifier).remove(option.name);
                } else {
                  ref.read(flavorOptionsRepositoryProvider.notifier).remove(option.name);
                }
              },
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              minimumSize: const Size(34, 34),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    String? helperText,
  }) {
    return InputDecoration(
      hintText: hint,
      helperText: helperText,
      filled: true,
      fillColor: IcebergTheme.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: IcebergTheme.vibrantRosePink, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ── Dialogs ──────────────────────────────────────────
  void _showAddModifierDialog(
    BuildContext context, {
    required String title,
    required void Function(ModifierOption) onSave,
  }) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '0.00');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: _inputDecoration(hint: 'Name (e.g. Cone)'),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                decoration: _inputDecoration(
                  hint: '0.00',
                  helperText: 'Set to 0 if no extra charge',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              onSave(ModifierOption(name: name, price: price));
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditModifierDialog(
    BuildContext context, {
    required String title,
    required ModifierOption option,
    required void Function(ModifierOption) onSave,
  }) {
    final nameCtrl = TextEditingController(text: option.name);
    final priceCtrl =
        TextEditingController(text: option.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: _inputDecoration(hint: 'Name'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                decoration: _inputDecoration(
                  hint: '0.00',
                  helperText: 'Set to 0 if no extra charge',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              onSave(ModifierOption(name: name, price: price));
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteModifier(
    ModifierOption item,
    void Function(ModifierOption) onDelete,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Delete Option'),
        content: Text('Remove "${item.name}" from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onDelete(item);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Premium reusable settings components
// =============================================================================

/// Section header with icon badge, title, subtitle, and optional action
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget? action;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// Card container with subtle border & rounded corners
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IcebergTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// Field row with label + icon on the left
class _SettingsField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SettingsField({
    required this.label,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.3,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Thin divider between fields
class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 16,
      endIndent: 16,
    );
  }
}

/// Small "Add" button for section headers
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IcebergTheme.vibrantRosePink.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded,
                  size: 16, color: IcebergTheme.vibrantRosePink),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                  color: IcebergTheme.vibrantRosePink,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state card for modifier sections
class _EmptyModifierCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EmptyModifierCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: IcebergTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add" above to get started',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
