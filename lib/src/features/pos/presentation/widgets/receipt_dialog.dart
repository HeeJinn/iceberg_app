import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../orders/domain/order.dart';
import '../../../products/domain/product.dart';

class ReceiptDialog extends StatelessWidget {
  final Order order;
  final List<Product> products;
  final String cashierName;

  const ReceiptDialog({
    super.key,
    required this.order,
    required this.products,
    required this.cashierName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: Color(0xFF4CAF50), size: 48),
              ),
              const SizedBox(height: 16),
              Text('Order Complete!',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Order #${order.id.substring(order.id.length - 6)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Divider(),

              // Items
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    String title;
                    try {
                      title = products
                          .firstWhere((p) => p.id == item.productId)
                          .title;
                    } catch (_) {
                      title = 'Item';
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('${item.quantity}x',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(title,
                                  style: const TextStyle(fontSize: 14))),
                          Text('\$${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 4),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: IcebergTheme.vibrantRosePink)),
                ],
              ),
              const SizedBox(height: 12),

              // Payment & Cashier
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment: ${order.paymentMethod}',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)),
                  Text(DateFormat('h:mm a').format(order.timestamp),
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Cashier: $cashierName',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('New Order',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
