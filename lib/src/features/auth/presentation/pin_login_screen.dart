import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/iceberg_theme.dart';
import '../../../core/layout/responsive_layout.dart';
import '../application/auth_controller.dart';

class PinLoginScreen extends ConsumerStatefulWidget {
  const PinLoginScreen({super.key});

  @override
  ConsumerState<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends ConsumerState<PinLoginScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _isLoading = false;
  String? _error;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
        _error = null;
      });
      if (_pin.length == 4) {
        _submitPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _error = null;
      });
    }
  }

  Future<void> _submitPin() async {
    setState(() {
      _isLoading = true;
    });

    final success =
        await ref.read(authControllerProvider.notifier).loginWithPin(_pin);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          _error = 'Invalid PIN. Please try again.';
          _pin = '';
          _shakeController.forward(from: 0);
        }
      });

      if (success) {
        context.go('/pos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildContent(context, isMobile: true),
        desktop: _buildContent(context, isMobile: false),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            IcebergTheme.lightGrey,
            IcebergTheme.creamPink.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Branding
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      IcebergTheme.creamPink,
                      IcebergTheme.vibrantRosePink.withValues(alpha: 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: IcebergTheme.vibrantRosePink, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color:
                          IcebergTheme.vibrantRosePink.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.icecream,
                      size: 64, color: IcebergTheme.vibrantRosePink),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Iceberg POS',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: IcebergTheme.vibrantRosePink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your PIN to access the terminal',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              // PIN Display with animation
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = _shakeController.value < 1.0
                      ? 10 *
                          (0.5 - _shakeController.value).abs() *
                          (_shakeController.value < 0.5 ? 1 : -1)
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFilled = index < _pin.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: isFilled ? 24 : 20,
                      height: isFilled ? 24 : 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled
                            ? IcebergTheme.vibrantRosePink
                            : Colors.transparent,
                        border: Border.all(
                          color: _error != null
                              ? Colors.red
                              : isFilled
                                  ? IcebergTheme.vibrantRosePink
                                  : Colors.grey.shade400,
                          width: 2,
                        ),
                        boxShadow: isFilled
                            ? [
                                BoxShadow(
                                  color: IcebergTheme.vibrantRosePink
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _error != null
                    ? Text(
                        _error!,
                        key: const ValueKey('error'),
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    : const SizedBox(key: ValueKey('no-error'), height: 16),
              ),
              const SizedBox(height: 24),

              // Numpad
              SizedBox(
                width: isMobile ? 280 : 320,
                child: Column(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var j = 1; j <= 3; j++)
                            _buildNumPadButton('${(i * 3) + j}'),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: isMobile ? 70 : 80), // spacer
                        _buildNumPadButton('0'),
                        _buildNumPadButton('⌫',
                            isAction: true, onPressed: _onDeletePressed),
                      ],
                    ),
                  ],
                ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    color: IcebergTheme.vibrantRosePink,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumPadButton(String text,
      {bool isAction = false, VoidCallback? onPressed}) {
    final size = ResponsiveLayout.isMobile(context) ? 70.0 : 80.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: isAction ? Colors.transparent : IcebergTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
        elevation: isAction ? 0 : 2,
        shadowColor: IcebergTheme.vibrantRosePink.withValues(alpha: 0.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed ?? () => _onDigitPressed(text),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: isAction
                ? null
                : BoxDecoration(
                    border: Border.all(
                        color: IcebergTheme.creamPink.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: isAction ? FontWeight.normal : FontWeight.bold,
                color: isAction
                    ? Colors.grey.shade700
                    : IcebergTheme.darkSlate,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
