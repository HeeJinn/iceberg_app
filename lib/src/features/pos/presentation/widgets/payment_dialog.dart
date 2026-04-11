import 'package:flutter/material.dart';
import '../../../../core/theme/iceberg_theme.dart';

class PaymentDialog extends StatefulWidget {
  final double totalAmount;
  final Function(String paymentMethod) onConfirm;

  const PaymentDialog({
    super.key,
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String _selectedMethod = 'Cash';
  final TextEditingController _cashReceivedCtrl = TextEditingController();
  double _change = 0;

  @override
  void dispose() {
    _cashReceivedCtrl.dispose();
    super.dispose();
  }

  void _calculateChange() {
    final received = double.tryParse(_cashReceivedCtrl.text) ?? 0;
    setState(() {
      _change = received - widget.totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.payment,
                      color: IcebergTheme.vibrantRosePink, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Payment',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
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
                    const Text('Total Due',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
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
              Text('Select Payment Method',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMethodChip('Cash', Icons.payments_outlined,
                      const Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  _buildMethodChip('GCash', Icons.phone_android,
                      const Color(0xFF2196F3)),
                  const SizedBox(width: 8),
                  _buildMethodChip('Card', Icons.credit_card,
                      const Color(0xFFFF9800)),
                ],
              ),
              const SizedBox(height: 20),

              // Cash-specific: Amount received + change
              if (_selectedMethod == 'Cash') ...[
                TextField(
                  controller: _cashReceivedCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cash Received',
                    prefixIcon: Icon(Icons.attach_money),
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
                      Text(_change >= 0 ? 'Change' : 'Insufficient',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _change >= 0
                                ? IcebergTheme.darkSlate
                                : Colors.red,
                          )),
                      Text(
                        '\$${_change.abs().toStringAsFixed(2)}',
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
                Text('Quick Amount',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [5, 10, 20, 50, 100]
                      .map((amount) => ActionChip(
                            label: Text('\$$amount'),
                            onPressed: () {
                              _cashReceivedCtrl.text =
                                  amount.toDouble().toStringAsFixed(2);
                              _calculateChange();
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Confirm Button
              ElevatedButton(
                onPressed: _canConfirm()
                    ? () {
                        widget.onConfirm(_selectedMethod);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: Text(
                  'Confirm ${_selectedMethod} Payment',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
        onTap: () => setState(() => _selectedMethod = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : IcebergTheme.lightGrey,
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
              Text(method,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? color : Colors.grey,
                    fontSize: 13,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
