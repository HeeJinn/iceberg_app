import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import 'package:iceberg_app/src/core/theme/iceberg_theme.dart';
import 'package:iceberg_app/src/features/products/domain/product.dart';
import 'package:iceberg_app/src/features/orders/domain/order.dart';
import 'package:iceberg_app/src/features/products/data/modifier_options_repository.dart';

class ModifierModal extends ConsumerStatefulWidget {
  final Product product;
  final Function(OrderItem) onAddToCart;

  const ModifierModal({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  ConsumerState<ModifierModal> createState() => _ModifierModalState();
}

class _ModifierModalState extends ConsumerState<ModifierModal> {
  int _quantity = 1;
  final Map<String, int> _modifiers = {};

  String? _selectedVesselName;

  void _incrementFlavor(String flavor) {
    setState(() {
      _modifiers[flavor] = (_modifiers[flavor] ?? 0) + 1;
    });
  }

  void _decrementFlavor(String flavor) {
    setState(() {
      if ((_modifiers[flavor] ?? 0) > 0) {
        _modifiers[flavor] = _modifiers[flavor]! - 1;
        if (_modifiers[flavor] == 0) {
          _modifiers.remove(flavor);
        }
      }
    });
  }

  void _submit() {
    final vessels = ref.read(vesselOptionsRepositoryProvider);
    double basePrice = widget.product.price;

    // Add vessel upcharge if any
    if (_selectedVesselName != null) {
      final vessel = vessels.firstWhere(
        (v) => v.name == _selectedVesselName,
        orElse: () => const ModifierOption(name: '', price: 0),
      );
      basePrice += vessel.price;
    }

    // Add flavor upcharges if any
    final flavors = ref.read(flavorOptionsRepositoryProvider);
    for (final entry in _modifiers.entries) {
      final flavor = flavors.firstWhere(
        (f) => f.name == entry.key,
        orElse: () => const ModifierOption(name: '', price: 0),
      );
      basePrice += flavor.price * entry.value;
    }

    final vesselLabel = _selectedVesselName ?? '';
    final Map<String, int> finalModifiers = {
      if (vesselLabel.isNotEmpty) vesselLabel: 1,
      ..._modifiers,
    };

    final orderItem = OrderItem(
      productId: widget.product.id,
      quantity: _quantity,
      modifiers: finalModifiers,
      subtotal: basePrice * _quantity,
    );

    widget.onAddToCart(orderItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vessels = ref.watch(vesselOptionsRepositoryProvider);
    final flavors = ref.watch(flavorOptionsRepositoryProvider);

    // Auto-select first vessel if none selected yet
    if (_selectedVesselName == null && vessels.isNotEmpty) {
      _selectedVesselName = vessels.first.name;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: IcebergTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formatCurrency(widget.product.price),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: IcebergTheme.vibrantRosePink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Vessel Selection ----
            Text(
              '1. Choose Vessel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (vessels.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'No vessel options configured',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: vessels.map((vessel) {
                  final isSelected = _selectedVesselName == vessel.name;
                  return ChoiceChip(
                    label: Text(vessel.displayLabel),
                    selected: isSelected,
                    selectedColor: IcebergTheme.mintBlueDark,
                    onSelected: (val) {
                      if (val) setState(() => _selectedVesselName = vessel.name);
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // ---- Flavor Selection ----
            Text(
              '2. Scoops & Flavors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (flavors.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'No flavor options configured',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: flavors.map((flavor) {
                      final count = _modifiers[flavor.name] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                flavor.price > 0
                                    ? '${flavor.name} (+${formatCurrency(flavor.price)})'
                                    : flavor.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _decrementFlavor(flavor.name),
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: IcebergTheme.darkSlate,
                              ),
                            ),
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _incrementFlavor(flavor.name),
                              icon: const Icon(
                                Icons.add_circle,
                                color: IcebergTheme.vibrantRosePink,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, size: 32),
                      color: IcebergTheme.darkSlate,
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Qty: $_quantity',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 32),
                      color: IcebergTheme.vibrantRosePink,
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Add to Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
