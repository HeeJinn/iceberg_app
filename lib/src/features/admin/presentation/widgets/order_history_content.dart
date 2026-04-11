import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../orders/data/order_repository.dart';
import '../../../orders/domain/order.dart';
import '../../../products/data/product_repository.dart';
import 'order_detail_dialog.dart';

class OrderHistoryContent extends ConsumerStatefulWidget {
  const OrderHistoryContent({super.key});

  @override
  ConsumerState<OrderHistoryContent> createState() =>
      _OrderHistoryContentState();
}

class _OrderHistoryContentState
    extends ConsumerState<OrderHistoryContent> {
  String _paymentFilter = 'All';
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(orderRepositoryProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    // Filter
    var orders = allOrders.toList();
    if (_paymentFilter != 'All') {
      orders = orders.where((o) => o.paymentMethod == _paymentFilter).toList();
    }
    if (_dateRange != null) {
      orders = orders.where((o) {
        return o.timestamp.isAfter(_dateRange!.start) &&
            o.timestamp.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    // Sort newest first
    orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order History',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  // Payment Filter
                  DropdownButton<String>(
                    value: _paymentFilter,
                    onChanged: (v) => setState(() => _paymentFilter = v ?? 'All'),
                    items: ['All', 'Cash', 'GCash', 'Card']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                  ),
                  // Date Range
                  OutlinedButton.icon(
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (range != null) {
                        setState(() => _dateRange = range);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_dateRange == null
                        ? 'Date Range'
                        : '${DateFormat('M/d').format(_dateRange!.start)} - ${DateFormat('M/d').format(_dateRange!.end)}'),
                  ),
                  if (_dateRange != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => setState(() => _dateRange = null),
                    ),
                ],
              ),
            ],
          ),
        ),
        // Order List
        Expanded(
          child: orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text('No orders found',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, ref, order);
                  },
                ),
        ),
        // Summary footer
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: IcebergTheme.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${orders.length} orders',
                  style: TextStyle(color: Colors.grey.shade600)),
              Text(
                'Total: \$${orders.fold(0.0, (sum, o) => sum + o.totalPrice).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IcebergTheme.vibrantRosePink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, WidgetRef ref, Order order) {
    final dateStr = DateFormat('MMM d, y · h:mm a').format(order.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _showOrderDetail(context, ref, order),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _paymentColor(order.paymentMethod).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _paymentIcon(order.paymentMethod),
            color: _paymentColor(order.paymentMethod),
          ),
        ),
        title: Text('Order #${order.id.substring(order.id.length - 6)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$dateStr · ${order.items.length} items'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${order.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: IcebergTheme.vibrantRosePink)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _paymentColor(order.paymentMethod).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(order.paymentMethod,
                  style: TextStyle(
                    fontSize: 11,
                    color: _paymentColor(order.paymentMethod),
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, WidgetRef ref, Order order) {
    final products = ref.read(productRepositoryProvider);
    showDialog(
      context: context,
      builder: (context) =>
          OrderDetailDialog(order: order, products: products),
    );
  }

  Color _paymentColor(String method) {
    switch (method) {
      case 'Cash':
        return const Color(0xFF4CAF50);
      case 'GCash':
        return const Color(0xFF2196F3);
      case 'Card':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  IconData _paymentIcon(String method) {
    switch (method) {
      case 'Cash':
        return Icons.payments_outlined;
      case 'GCash':
        return Icons.phone_android;
      case 'Card':
        return Icons.credit_card;
      default:
        return Icons.receipt;
    }
  }
}
