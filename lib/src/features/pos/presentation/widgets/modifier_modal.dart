import 'package:flutter/material.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import 'package:iceberg_app/src/core/theme/iceberg_theme.dart';
import 'package:iceberg_app/src/features/products/domain/product.dart';
import 'package:iceberg_app/src/features/orders/domain/order.dart';

class ModifierModal extends StatefulWidget {
  final Product product;
  final Function(OrderItem) onAddToCart;

  const ModifierModal({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ModifierModal> createState() => _ModifierModalState();
}

class _ModifierModalState extends State<ModifierModal> {
  int _quantity = 1;
  final Map<String, int> _modifiers = {};

  final List<String> _availableVessels = [
    'Cup',
    'Sugar Cone',
    'Waffle Cone (+₱0.50)',
  ];
  final List<String> _availableFlavors = [
    'Vanilla',
    'Chocolate',
    'Strawberry',
    'Mint Chip',
    'Cookies & Cream',
  ];

  String _selectedVessel = 'Cup';

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
    double basePrice = widget.product.price;
    if (_selectedVessel.contains('+')) {
      // Basic mock extraction of upcharge purely for demonstration
      basePrice += 0.50;
    }

    final Map<String, int> finalModifiers = {_selectedVessel: 1, ..._modifiers};

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

            Text(
              '1. Choose Vessel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableVessels.map((vessel) {
                final isSelected = _selectedVessel == vessel;
                return ChoiceChip(
                  label: Text(vessel),
                  selected: isSelected,
                  selectedColor: IcebergTheme.mintBlueDark,
                  onSelected: (val) {
                    if (val) setState(() => _selectedVessel = vessel);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            Text(
              '2. Scoops & Flavors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: _availableFlavors.map((flavor) {
                    final count = _modifiers[flavor] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              flavor,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _decrementFlavor(flavor),
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
                            onPressed: () => _incrementFlavor(flavor),
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
