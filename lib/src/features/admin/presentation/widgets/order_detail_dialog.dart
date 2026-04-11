import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../orders/domain/order.dart';
import '../../../products/domain/product.dart';

class OrderDetailDialog extends StatelessWidget {
  final Order order;
  final List<Product> products;

  const OrderDetailDialog({
    super.key,
    required this.order,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long, color: IcebergTheme.vibrantRosePink),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Order #${order.id.substring(order.id.length - 6)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMMM d, y · h:mm a').format(order.timestamp),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Items
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    String title;
                    try {
                      title = products.firstWhere((p) => p.id == item.productId).title;
                    } catch (_) {
                      title = 'Product ${item.productId}';
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: IcebergTheme.creamPink.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text('${item.quantity}x',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                if (item.modifiers.isNotEmpty)
                                  Text(
                                    item.modifiers.entries
                                        .map((e) => '${e.key}: ${e.value}')
                                        .join(', '),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                  ),
                              ],
                            ),
                          ),
                          Text('\$${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('\$${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: IcebergTheme.vibrantRosePink)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Paid via ${order.paymentMethod}',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
              if (order.staffId.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('Cashier: ${order.staffId}',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
