import 'package:flutter/material.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';

class PaymentDialog extends StatefulWidget {
  final double totalAmount;
  final Future<void> Function(String paymentMethod) onConfirm;

  const PaymentDialog({
    super.key,
    required this.totalAmount,
    required this.onConfirm,
  });

  /// Show payment as a bottom sheet on mobile, dialog on tablet/desktop.
  static Future<void> show(
    BuildContext context, {
    required double totalAmount,
    required Future<void> Function(String paymentMethod) onConfirm,
  }) {
    if (ResponsiveLayout.isMobile(context)) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _MobilePaymentSheet(
          totalAmount: totalAmount,
          onConfirm: onConfirm,
        ),
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PaymentDialog(
          totalAmount: totalAmount,
          onConfirm: onConfirm,
        ),
      );
    }
  }

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

// =============================================================================
// Desktop / Tablet Dialog version (unchanged layout, wrapped in scroll)
// =============================================================================
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

    await Future.delayed(const Duration(milliseconds: 400));

    try {
      await widget.onConfirm(_selectedMethod);

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      _successAnimCtrl.forward();

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

  Widget _buildPaymentForm(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildTotalDue(),
          const SizedBox(height: 24),
          _buildMethodSelector(context),
          const SizedBox(height: 20),
          if (_selectedMethod == 'Cash') ..._buildCashSection(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildTotalDue() {
    return Container(
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              formatCurrency(widget.totalAmount),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: IcebergTheme.vibrantRosePink,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  List<Widget> _buildCashSection() {
    return [
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
                color: _change >= 0 ? IcebergTheme.darkSlate : Colors.red,
              ),
            ),
            Text(
              formatCurrency(_change.abs()),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _change >= 0 ? IcebergTheme.darkSlate : Colors.red,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
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
                  _cashReceivedCtrl.text =
                      amount.toDouble().toStringAsFixed(2);
                  _calculateChange();
                },
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 20),
    ];
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed:
          _canConfirm() && !_isProcessing ? _handleConfirm : null,
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

// =============================================================================
// Mobile Bottom Sheet version — avoids keyboard overflow entirely
// =============================================================================
class _MobilePaymentSheet extends StatefulWidget {
  final double totalAmount;
  final Future<void> Function(String paymentMethod) onConfirm;

  const _MobilePaymentSheet({
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  State<_MobilePaymentSheet> createState() => _MobilePaymentSheetState();
}

class _MobilePaymentSheetState extends State<_MobilePaymentSheet>
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
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      await widget.onConfirm(_selectedMethod);

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      _successAnimCtrl.forward();

      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  }

  bool _canConfirm() {
    if (_selectedMethod == 'Cash') {
      return _change >= 0 && _cashReceivedCtrl.text.isNotEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: IcebergTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSuccess ? _buildSuccessView(context) : _buildForm(context, bottomInset),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      key: const ValueKey('success_mobile'),
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
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, double bottomInset) {
    return Column(
      key: const ValueKey('form_mobile'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Scrollable content
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: bottomInset + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.payment,
                      color: IcebergTheme.vibrantRosePink,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Payment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed:
                          _isProcessing ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Total Due
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: IcebergTheme.lightGrey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Due',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        formatCurrency(widget.totalAmount),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: IcebergTheme.vibrantRosePink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Payment Methods
                Text(
                  'Select Payment Method',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildMethodChip(
                        'Cash', Icons.payments_outlined, const Color(0xFF4CAF50)),
                    const SizedBox(width: 8),
                    _buildMethodChip(
                        'GCash', Icons.phone_android, const Color(0xFF2196F3)),
                    const SizedBox(width: 8),
                    _buildMethodChip(
                        'Card', Icons.credit_card, const Color(0xFFFF9800)),
                  ],
                ),
                const SizedBox(height: 16),

                // Cash-specific
                if (_selectedMethod == 'Cash') ...[
                  TextField(
                    controller: _cashReceivedCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Cash Received',
                      prefixIcon: Icon(Icons.payments_outlined),
                      prefixText: '\u20B1 ',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateChange(),
                    autofocus: true,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _change >= 0
                                ? IcebergTheme.darkSlate
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Quick Amount',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [20, 50, 100, 200, 500]
                        .map((amount) => ActionChip(
                              label: Text(
                                formatCurrency(amount, decimalDigits: 0),
                                style: const TextStyle(fontSize: 13),
                              ),
                              onPressed: () {
                                _cashReceivedCtrl.text =
                                    amount.toDouble().toStringAsFixed(2);
                                _calculateChange();
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Confirm Button
                SafeArea(
                  top: false,
                  child: ElevatedButton(
                    onPressed: _canConfirm() && !_isProcessing
                        ? _handleConfirm
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
              const SizedBox(height: 3),
              Text(
                method,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
