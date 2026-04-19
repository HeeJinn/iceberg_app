import 'package:flutter/material.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import '../../../../core/theme/iceberg_theme.dart';

class PaymentDialog extends StatefulWidget {
  final double totalAmount;
  final Future<void> Function(String paymentMethod) onConfirm;

  const PaymentDialog({
    super.key,
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog>
    with SingleTickerProviderStateMixin {
  String _selectedMethod = 'Cash';
  final TextEditingController _cashReceivedCtrl = TextEditingController();
  double _change = 0;
  bool _isProcessing = false;
  bool _isSuccess = false;

  late final AnimationController _successAnimCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _successAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _successAnimCtrl,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _successAnimCtrl,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _cashReceivedCtrl.dispose();
    _successAnimCtrl.dispose();
    super.dispose();
  }

  void _calculateChange() {
    final received = double.tryParse(_cashReceivedCtrl.text) ?? 0;
    setState(() {
      _change = received - widget.totalAmount;
    });
  }

  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);

    // Brief delay to show processing state
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      // Trigger the callback and wait for checkout to complete
      await widget.onConfirm(_selectedMethod);

      if (!mounted) return;

      // Show success state
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      _successAnimCtrl.forward();

      // Auto-close after showing success
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSuccess
              ? _buildSuccessView(context)
              : _buildPaymentForm(context),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Success View — shown briefly after payment is confirmed
  // -----------------------------------------------------------------------
  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF4CAF50),
                  size: 64,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              'Payment Successful!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: IcebergTheme.darkSlate,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              '${formatCurrency(widget.totalAmount)} via $_selectedMethod',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Payment Form — the normal payment UI
  // -----------------------------------------------------------------------
  Widget _buildPaymentForm(BuildContext context) {
    return Padding(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payment,
                color: IcebergTheme.vibrantRosePink,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Payment',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _isProcessing ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: IcebergTheme.lightGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Due',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatCurrency(widget.totalAmount),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: IcebergTheme.vibrantRosePink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Payment Methods
          Text(
            'Select Payment Method',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMethodChip(
                'Cash',
                Icons.payments_outlined,
                const Color(0xFF4CAF50),
              ),
              const SizedBox(width: 8),
              _buildMethodChip(
                'GCash',
                Icons.phone_android,
                const Color(0xFF2196F3),
              ),
              const SizedBox(width: 8),
              _buildMethodChip(
                'Card',
                Icons.credit_card,
                const Color(0xFFFF9800),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cash-specific: Amount received + change
          if (_selectedMethod == 'Cash') ...[
            TextField(
              controller: _cashReceivedCtrl,
              decoration: const InputDecoration(
                labelText: 'Cash Received',
                prefixIcon: Icon(Icons.payments_outlined),
                prefixText: '\u20B1 ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculateChange(),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _change >= 0
                    ? IcebergTheme.mintBlue.withValues(alpha: 0.5)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _change >= 0 ? 'Change' : 'Insufficient',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _change >= 0
                          ? IcebergTheme.darkSlate
                          : Colors.red,
                    ),
                  ),
                  Text(
                    formatCurrency(_change.abs()),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _change >= 0
                          ? IcebergTheme.darkSlate
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Quick Cash Amounts
          if (_selectedMethod == 'Cash') ...[
            Text(
              'Quick Amount',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [20, 50, 100, 200, 500]
                  .map(
                    (amount) => ActionChip(
                      label: Text(formatCurrency(amount, decimalDigits: 0)),
                      onPressed: () {
                        _cashReceivedCtrl.text = amount
                            .toDouble()
                            .toStringAsFixed(2);
                        _calculateChange();
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Confirm Button
          ElevatedButton(
            onPressed: _canConfirm() && !_isProcessing
                ? _handleConfirm
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Confirm $_selectedMethod Payment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  bool _canConfirm() {
    if (_selectedMethod == 'Cash') {
      return _change >= 0 && _cashReceivedCtrl.text.isNotEmpty;
    }
    return true;
  }

  Widget _buildMethodChip(String method, IconData icon, Color color) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: _isProcessing
            ? null
            : () => setState(() => _selectedMethod = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : IcebergTheme.lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 28),
              const SizedBox(height: 4),
              Text(
                method,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
