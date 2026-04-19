import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/theme/iceberg_theme.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../products/data/product_repository.dart';
import '../../products/data/category_repository.dart';
import '../../products/domain/product.dart';
import '../../orders/application/cart_controller.dart';
import '../../orders/domain/order.dart';
import '../../auth/application/auth_controller.dart';
import 'widgets/modifier_modal.dart';
import 'widgets/payment_dialog.dart';
import 'widgets/receipt_dialog.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  String? _selectedCategory; // null = All

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileBase(context),
        desktop: _buildTabletDesktopBase(context),
      ),
    );
  }

  Widget _buildTabletDesktopBase(BuildContext context) {
    return Row(
      children: [
        // Main Product Grid Area
        Expanded(
          flex: ResponsiveLayout.isTablet(context) ? 6 : 7,
          child: Container(
            color: IcebergTheme.lightGrey,
            child: _buildMainColumn(context, isMobile: false),
          ),
        ),
        // Shopping Cart Sidebar
        Expanded(
          flex: ResponsiveLayout.isTablet(context) ? 4 : 3,
          child: Container(
            decoration: BoxDecoration(
              color: IcebergTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(-5, 0),
                ),
              ],
            ),
            child: _buildCartPanel(context, isMobile: false),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBase(BuildContext context) {
    final cart = ref.watch(cartControllerProvider);

    return Stack(
      children: [
        Container(
          color: IcebergTheme.lightGrey,
          padding: const EdgeInsets.only(bottom: 80), // padding for cart bar
          child: _buildMainColumn(context, isMobile: true),
        ),

        // Sticky Mobile Cart Footer
        if (cart.items.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showMobileCartSheet(context),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: IcebergTheme.darkSlate,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: IcebergTheme.vibrantRosePink,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.items.length}',
                            style: const TextStyle(
                              color: IcebergTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'View Cart',
                          style: TextStyle(
                            color: IcebergTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatCurrency(cart.totalPrice),
                      style: const TextStyle(
                        color: IcebergTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showMobileCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: IcebergTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(child: _buildCartPanel(context, isMobile: true)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainColumn(BuildContext context, {required bool isMobile}) {
    final products = ref.watch(productRepositoryProvider);
    final categories = ref.watch(categoryRepositoryProvider);
    final auth = ref.watch(authControllerProvider);

    // Filter products by category
    final filteredProducts = products.where((p) {
      if (!p.isAvailable) return false;
      if (_selectedCategory != null) {
        // Match against customCategory if set, or enum label
        final productCat = p.customCategory.isNotEmpty
            ? p.customCategory
            : _enumToLabel(p.category);
        if (productCat != _selectedCategory) return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/iceberg_logo.jpg',
                      height: isMobile ? 40 : 48,
                    ),
                    const SizedBox(width: 12),
                    if (auth != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            auth.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: IcebergTheme.darkSlate,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  children: [
                    if (auth != null && auth.isAdmin)
                      IconButton(
                        icon: const Icon(
                          Icons.admin_panel_settings,
                          color: IcebergTheme.darkSlate,
                        ),
                        onPressed: () => context.go('/admin'),
                        tooltip: 'Admin Dashboard',
                      ),
                    if (!isMobile) ...[
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/clock-out'),
                        icon: const Icon(Icons.access_time),
                        label: const Text('Clock Out'),
                      ),
                    ] else ...[
                      IconButton(
                        icon: const Icon(
                          Icons.access_time,
                          color: IcebergTheme.darkSlate,
                        ),
                        onPressed: () => context.go('/clock-out'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Category Filter Tabs â€” dynamic from CategoryRepository
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
            children: [
              _buildCategoryChip('All', null, isMobile),
              ...categories.map(
                (cat) => _buildCategoryChip(cat, cat, isMobile),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Product Grid
        Expanded(
          child: filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.icecream,
                        size: 64,
                        color: IcebergTheme.creamPink,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No products in this category',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 24,
                    vertical: 8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 2
                        : (ResponsiveLayout.isTablet(context) ? 3 : 4),
                    childAspectRatio: isMobile ? 0.75 : 0.85,
                    crossAxisSpacing: isMobile ? 12 : 16,
                    mainAxisSpacing: isMobile ? 12 : 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(context, product, isMobile);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, String? category, bool isMobile) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = category),
        selectedColor: IcebergTheme.creamPink,
        checkmarkColor: IcebergTheme.vibrantRosePink,
        labelStyle: TextStyle(
          color: isSelected
              ? IcebergTheme.vibrantRosePink
              : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: isMobile ? 12 : 14,
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    bool isMobile,
  ) {
    // Check if product has a base64 image
    final hasImage =
        product.imageUrl.isNotEmpty &&
        (product.imageUrl.startsWith('data:') || product.imageUrl.length > 200);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (c) => ModifierModal(
              product: product,
              onAddToCart: (OrderItem orderItem) {
                ref.read(cartControllerProvider.notifier).addItem(orderItem);
                if (isMobile) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart'),
                      duration: const Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: hasImage
                  ? _buildBase64Image(product.imageUrl)
                  : Container(
                      color: IcebergTheme.creamPink.withValues(alpha: 0.2),
                      child: Center(
                        child: Icon(
                          _categoryIcon(product.category),
                          size: 48,
                          color: IcebergTheme.vibrantRosePink,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(product.price),
                        style: const TextStyle(
                          color: IcebergTheme.vibrantRosePink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: IcebergTheme.mintBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _categoryShortLabel(product),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBase64Image(String dataUrl) {
    try {
      final raw = dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(raw);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: IcebergTheme.creamPink.withValues(alpha: 0.2),
          child: const Center(
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        ),
      );
    } catch (_) {
      return Container(
        color: IcebergTheme.creamPink.withValues(alpha: 0.2),
        child: const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildCartPanel(BuildContext context, {required bool isMobile}) {
    final cart = ref.watch(cartControllerProvider);
    final products = ref.watch(productRepositoryProvider);
    final auth = ref.watch(authControllerProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Order',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  ref.read(cartControllerProvider.notifier).clearCart();
                  if (isMobile) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: cart.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Cart is empty',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap a product to add it',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    String title;
                    try {
                      title = products
                          .firstWhere((p) => p.id == item.productId)
                          .title;
                    } catch (_) {
                      title = 'Item';
                    }
                    return Dismissible(
                      key: ValueKey('${item.productId}_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red.shade50,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(cartControllerProvider.notifier)
                            .removeItem(index);
                      },
                      child: ListTile(
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text(
                          formatCurrency(item.subtotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrency(cart.totalPrice),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: IcebergTheme.vibrantRosePink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () => _showPaymentDialog(context, cart, auth),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: IcebergTheme.vibrantRosePink,
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentDialog(BuildContext context, Order cart, dynamic auth) {
    // Close mobile cart sheet if open
    final isMobile = ResponsiveLayout.isMobile(context);

    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        totalAmount: cart.totalPrice,
        onConfirm: (paymentMethod) async {
          final staffId = auth?.id ?? '';
          final staffName = auth?.name ?? '';
          final completedOrder = await ref
              .read(cartControllerProvider.notifier)
              .checkout(paymentMethod, staffId);

          if (isMobile && mounted) {
            // Pop the bottom sheet
            Navigator.of(context).popUntil(
              (route) => route.isFirst || !Navigator.of(context).canPop(),
            );
          }

          if (mounted) {
            final products = ref.read(productRepositoryProvider);
            showDialog(
              context: this.context,
              builder: (c) => ReceiptDialog(
                order: completedOrder,
                products: products,
                cashierName: staffName,
              ),
            );
          }
        },
      ),
    );
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

  String _categoryShortLabel(Product product) {
    if (product.customCategory.isNotEmpty) {
      return product.customCategory;
    }
    return _enumToLabel(product.category);
  }
}
