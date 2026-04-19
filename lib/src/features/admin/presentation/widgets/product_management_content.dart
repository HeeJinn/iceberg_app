import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../products/data/product_repository.dart';
import '../../../products/data/category_repository.dart';
import '../../../products/domain/product.dart';
import 'product_form_dialog.dart';
import 'category_manager_dialog.dart';

class ProductManagementContent extends ConsumerStatefulWidget {
  const ProductManagementContent({super.key});

  @override
  ConsumerState<ProductManagementContent> createState() =>
      _ProductManagementContentState();
}

class _ProductManagementContentState
    extends ConsumerState<ProductManagementContent> {
  String _searchQuery = '';
  String? _selectedCategory; // null = All

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productRepositoryProvider);
    final categories = ref.watch(categoryRepositoryProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    final filtered = products.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      if (!matchesSearch) return false;
      if (_selectedCategory == null) return true;
      final productCat = p.customCategory.isNotEmpty
          ? p.customCategory
          : _enumToLabel(p.category);
      return productCat == _selectedCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Product Management',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  // Manage Categories button
                  if (!isMobile)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton.icon(
                        onPressed: () => _showCategoryManager(context),
                        icon: const Icon(Icons.category_outlined, size: 18),
                        label: const Text('Categories'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  if (isMobile)
                    IconButton(
                      onPressed: () => _showCategoryManager(context),
                      icon: const Icon(Icons.category_outlined),
                      tooltip: 'Manage Categories',
                    ),
                  ElevatedButton.icon(
                    onPressed: () => _showProductForm(context, ref),
                    icon: const Icon(Icons.add),
                    label: Text(isMobile ? 'Add' : 'Add Product'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search & Category Filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String?>(
                    value: _selectedCategory,
                    hint: const Text('All'),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Product List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return _buildProductTile(context, ref, product);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductTile(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    final hasImage =
        product.imageUrl.isNotEmpty &&
        (product.imageUrl.startsWith('data:') || product.imageUrl.length > 200);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: product.isAvailable
              ? IcebergTheme.creamPink.withValues(alpha: 0.5)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasImage
            ? _buildBase64Thumb(product.imageUrl)
            : Icon(
                _categoryIcon(product.category),
                color: product.isAvailable
                    ? IcebergTheme.vibrantRosePink
                    : Colors.grey,
              ),
      ),
      title: Text(
        product.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: product.isAvailable ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            formatCurrency(product.price),
            style: const TextStyle(
              color: IcebergTheme.vibrantRosePink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: IcebergTheme.mintBlue.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _categoryLabel(product),
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Cost: ${formatCurrency(product.cost)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: product.isAvailable,
            onChanged: (_) => ref
                .read(productRepositoryProvider.notifier)
                .toggleAvailability(product.id),
            activeTrackColor: IcebergTheme.vibrantRosePink,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _showProductForm(context, ref, product: product),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: Colors.red.shade400,
            ),
            onPressed: () => _confirmDelete(context, ref, product),
          ),
        ],
      ),
    );
  }

  Widget _buildBase64Thumb(String dataUrl) {
    try {
      final raw = dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(raw);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (_) {
      return const Icon(Icons.broken_image, color: Colors.grey);
    }
  }

  void _showProductForm(
    BuildContext context,
    WidgetRef ref, {
    Product? product,
  }) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        product: product,
        onSave: (p) {
          if (product == null) {
            ref.read(productRepositoryProvider.notifier).addProduct(p);
          } else {
            ref.read(productRepositoryProvider.notifier).updateProduct(p);
          }
        },
      ),
    );
  }

  void _showCategoryManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CategoryManagerDialog(),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(productRepositoryProvider.notifier)
                  .deleteProduct(product.id);
              Navigator.pop(context);
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

  String _categoryLabel(Product product) {
    if (product.customCategory.isNotEmpty) {
      return product.customCategory;
    }
    return _enumToLabel(product.category);
  }

  String _enumToLabel(ProductCategory c) {
    switch (c) {
      case ProductCategory.iceCream:
        return 'Ice Cream';
      case ProductCategory.vessel:
        return 'Vessel';
      case ProductCategory.topping:
        return 'Topping';
      case ProductCategory.drink:
        return 'Drink';
      case ProductCategory.other:
        return 'Other';
    }
  }

  IconData _categoryIcon(ProductCategory c) {
    switch (c) {
      case ProductCategory.iceCream:
        return Icons.icecream;
      case ProductCategory.vessel:
        return Icons.coffee;
      case ProductCategory.topping:
        return Icons.auto_awesome;
      case ProductCategory.drink:
        return Icons.local_drink;
      case ProductCategory.other:
        return Icons.category;
    }
  }
}
