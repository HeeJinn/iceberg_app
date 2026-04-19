import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:iceberg_app/src/core/theme/iceberg_theme.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import '../../auth/application/auth_controller.dart';
import '../../orders/data/order_repository.dart';
import '../../reports/data/shift_report_repository.dart';
import '../../reports/domain/shift_report.dart';

class ClockOutScreen extends ConsumerStatefulWidget {
  const ClockOutScreen({super.key});

  @override
  ConsumerState<ClockOutScreen> createState() => _ClockOutScreenState();
}

class _ClockOutScreenState extends ConsumerState<ClockOutScreen> {
  final TextEditingController _cashController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final orders = ref.watch(orderRepositoryProvider);

    // Compute today's totals
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final todaysOrders = orders
        .where((o) => o.timestamp.isAfter(startOfDay))
        .toList();
    final systemTotal = todaysOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
    final cashOrders = todaysOrders
        .where((o) => o.paymentMethod == 'Cash')
        .toList();
    final cashTotal = cashOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
    final gcashOrders = todaysOrders
        .where((o) => o.paymentMethod == 'GCash')
        .toList();
    final gcashTotal = gcashOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
    final cardOrders = todaysOrders
        .where((o) => o.paymentMethod == 'Card')
        .toList();
    final cardTotal = cardOrders.fold(0.0, (sum, o) => sum + o.totalPrice);

    final declaredCash = double.tryParse(_cashController.text) ?? 0;
    final discrepancy = declaredCash - cashTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('End of Day - Z-Reading'),
        backgroundColor: IcebergTheme.white,
        foregroundColor: IcebergTheme.darkSlate,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            size: 48,
                            color: IcebergTheme.vibrantRosePink,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Shift Summary',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${auth?.name ?? "Staff"} · ${DateFormat('MMMM d, y').format(now)}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sales Breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales Breakdown',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Total Sales',
                            formatCurrency(systemTotal),
                            isBold: true,
                            color: IcebergTheme.vibrantRosePink,
                          ),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            'Cash (${cashOrders.length} orders)',
                            formatCurrency(cashTotal),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'GCash (${gcashOrders.length} orders)',
                            formatCurrency(gcashTotal),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Card (${cardOrders.length} orders)',
                            formatCurrency(cardTotal),
                          ),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            'Total Orders',
                            '${todaysOrders.length}',
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Average Order',
                            todaysOrders.isEmpty
                                ? formatCurrency(0)
                                : formatCurrency(
                                    systemTotal / todaysOrders.length,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cash Declaration
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cash Declaration',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'System Expected Cash:',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            formatCurrency(cashTotal),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _cashController,
                            decoration: InputDecoration(
                              labelText: 'Actual Drawer Cash',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.payments_outlined),
                              prefixText: '\u20B1 ',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          if (_cashController.text.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: discrepancy.abs() < 0.01
                                    ? IcebergTheme.mintBlue.withValues(
                                        alpha: 0.5,
                                      )
                                    : discrepancy > 0
                                    ? const Color(
                                        0xFF4FC3F7,
                                      ).withValues(alpha: 0.15)
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    discrepancy.abs() < 0.01
                                        ? 'Balanced ✓'
                                        : discrepancy > 0
                                        ? 'Overage'
                                        : 'Shortage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: discrepancy.abs() < 0.01
                                          ? const Color(0xFF4CAF50)
                                          : discrepancy > 0
                                          ? const Color(0xFF2196F3)
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    formatCurrency(discrepancy.abs()),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: discrepancy.abs() < 0.01
                                          ? const Color(0xFF4CAF50)
                                          : discrepancy > 0
                                          ? const Color(0xFF2196F3)
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _isSubmitting || _cashController.text.isEmpty
                        ? null
                        : () => _submitClockOut(
                            context,
                            auth?.id ?? '',
                            systemTotal,
                            declaredCash,
                            discrepancy,
                          ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: IcebergTheme.white,
                            ),
                          )
                        : const Text(
                            'Submit & Clock Out',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? null : Colors.grey.shade700,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 20 : 16,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _submitClockOut(
    BuildContext context,
    String staffId,
    double systemTotal,
    double declaredCash,
    double discrepancy,
  ) async {
    setState(() => _isSubmitting = true);

    final report = ShiftReport(
      id: const Uuid().v4(),
      staffId: staffId,
      startTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        8,
        0,
      ), // assume 8am start
      endTime: DateTime.now(),
      systemTotal: systemTotal,
      declaredCash: declaredCash,
      discrepancy: discrepancy,
    );

    await ref.read(shiftReportRepositoryProvider.notifier).saveReport(report);

    // Logout
    ref.read(authControllerProvider.notifier).logout();

    if (mounted) {
      context.go('/login');
    }
  }
}
