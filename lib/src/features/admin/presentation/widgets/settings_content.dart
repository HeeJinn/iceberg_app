import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../../../core/theme/iceberg_theme.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
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
}
