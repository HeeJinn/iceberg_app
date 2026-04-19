import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../../../core/theme/iceberg_theme.dart';
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
      const SnackBar(
        content: Text('Settings saved!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: IcebergTheme.vibrantRosePink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vessels = ref.watch(vesselOptionsRepositoryProvider);
    final flavors = ref.watch(flavorOptionsRepositoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Configure your store preferences',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 32),

          // Store Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: IcebergTheme.creamPink.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.store,
                            color: IcebergTheme.vibrantRosePink),
                      ),
                      const SizedBox(width: 16),
                      Text('Store Information',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _storeNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Store Name',
                      prefixIcon: Icon(Icons.storefront),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _taxRateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tax Rate (%)',
                      prefixIcon: Icon(Icons.percent),
                      helperText: 'Set to 0 if no tax applies',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Receipt Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: IcebergTheme.mintBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.receipt_long,
                            color: IcebergTheme.darkSlate),
                      ),
                      const SizedBox(width: 16),
                      Text('Receipt Settings',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _receiptHeaderCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Receipt Header',
                      prefixIcon: Icon(Icons.title),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _receiptFooterCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Receipt Footer',
                      prefixIcon: Icon(Icons.short_text),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Vessel Options ----
          _buildModifierCard(
            context: context,
            title: 'Vessel Options',
            subtitle: 'Manage the vessel choices shown when ordering (e.g. Cup, Cone)',
            icon: Icons.coffee,
            iconBgColor: const Color(0xFFFFE0B2),
            iconColor: const Color(0xFFE65100),
            items: vessels,
            onAdd: () => _showAddModifierDialog(
              context,
              title: 'Add Vessel',
              onSave: (option) {
                ref.read(vesselOptionsRepositoryProvider.notifier).add(option);
              },
            ),
            onEdit: (option) => _showEditModifierDialog(
              context,
              title: 'Edit Vessel',
              option: option,
              onSave: (updated) {
                ref
                    .read(vesselOptionsRepositoryProvider.notifier)
                    .update(option.name, updated);
              },
            ),
            onDelete: (option) {
              ref
                  .read(vesselOptionsRepositoryProvider.notifier)
                  .remove(option.name);
            },
          ),
          const SizedBox(height: 16),

          // ---- Flavor Options ----
          _buildModifierCard(
            context: context,
            title: 'Flavor Options',
            subtitle: 'Manage the scoop flavors available for ice cream orders',
            icon: Icons.icecream,
            iconBgColor: IcebergTheme.creamPink.withValues(alpha: 0.5),
            iconColor: IcebergTheme.vibrantRosePink,
            items: flavors,
            onAdd: () => _showAddModifierDialog(
              context,
              title: 'Add Flavor',
              onSave: (option) {
                ref.read(flavorOptionsRepositoryProvider.notifier).add(option);
              },
            ),
            onEdit: (option) => _showEditModifierDialog(
              context,
              title: 'Edit Flavor',
              option: option,
              onSave: (updated) {
                ref
                    .read(flavorOptionsRepositoryProvider.notifier)
                    .update(option.name, updated);
              },
            ),
            onDelete: (option) {
              ref
                  .read(flavorOptionsRepositoryProvider.notifier)
                  .remove(option.name);
            },
          ),
          const SizedBox(height: 16),

          // About
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF4FC3F7).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.info_outline,
                            color: Color(0xFF4FC3F7)),
                      ),
                      const SizedBox(width: 16),
                      Text('About',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Iceberg POS'),
                    subtitle: Text('Version 1.0.0'),
                    trailing: Icon(Icons.icecream, color: IcebergTheme.vibrantRosePink),
                  ),
                  Text('Offline-first Point of Sale system for ice cream businesses.',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Reusable modifier management card
  // -------------------------------------------------------------------------
  Widget _buildModifierCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required List<ModifierOption> items,
    required VoidCallback onAdd,
    required void Function(ModifierOption) onEdit,
    required void Function(ModifierOption) onDelete,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'No options configured yet',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              )
            else
              ...items.map((item) => _buildModifierTile(item, onEdit, onDelete)),
          ],
        ),
      ),
    );
  }

  Widget _buildModifierTile(
    ModifierOption item,
    void Function(ModifierOption) onEdit,
    void Function(ModifierOption) onDelete,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        item.price > 0
            ? 'Extra charge: \u20B1${item.price.toStringAsFixed(2)}'
            : 'No extra charge',
        style: TextStyle(
          fontSize: 12,
          color: item.price > 0 ? IcebergTheme.vibrantRosePink : Colors.grey.shade500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => onEdit(item),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade400),
            onPressed: () => _confirmDeleteModifier(item, onDelete),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Add / Edit / Delete dialogs
  // -------------------------------------------------------------------------
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
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                labelText: 'Extra Price (\u20B1)',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('\u20B1', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                helperText: 'Set to 0 if no extra charge',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
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
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                labelText: 'Extra Price (\u20B1)',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('\u20B1', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                helperText: 'Set to 0 if no extra charge',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
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
