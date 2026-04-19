import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/iceberg_theme.dart';
import '../../../core/layout/responsive_layout.dart';
import '../application/auth_controller.dart';

class PinLoginScreen extends ConsumerStatefulWidget {
  const PinLoginScreen({super.key});

  @override
  ConsumerState<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends ConsumerState<PinLoginScreen>
    with TickerProviderStateMixin {
  String _pin = '';
  bool _isLoading = false;
  String? _error;
  late final AnimationController _shakeController;
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _entryFade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    _entryController.forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _entryController.dispose();
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
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Desktop: side-by-side branding + PIN card
  // ──────────────────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left — brand panel
        Expanded(
          flex: 5,
          child: _buildBrandPanel(),
        ),
        // Right — login form
        Expanded(
          flex: 4,
          child: _buildLoginPanel(context, isMobile: false),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  //  Mobile: stacked layout
  // ──────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF5F7),
            Colors.white,
            Colors.white,
          ],
          stops: [0.0, 0.35, 1.0],
        ),
      ),
      child: SafeArea(
        child: _buildLoginPanel(context, isMobile: true),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Brand panel (desktop left side)
  // ──────────────────────────────────────────────
  Widget _buildBrandPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8384F),
            Color(0xFFD42E44),
            Color(0xFFBE2539),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 60,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo on brand panel
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/iceberg_logo.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Iceberg POS',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Point of Sale System',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Feature highlights
                  _buildFeatureItem(Icons.speed_rounded, 'Fast & Intuitive'),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                      Icons.cloud_off_rounded, 'Offline-First Ready'),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                      Icons.security_rounded, 'Secure PIN Access'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  //  Login panel (works for both mobile & desktop)
  // ──────────────────────────────────────────────
  Widget _buildLoginPanel(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);

    return Container(
      color: isMobile ? Colors.transparent : Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: 32,
          ),
          child: SlideTransition(
            position: _entrySlide,
            child: FadeTransition(
              opacity: _entryFade,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mobile-only: logo & brand at top
                  if (isMobile) ...[
                    // Logo with subtle shadow
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: IcebergTheme.vibrantRosePink
                                .withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/iceberg_logo.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Iceberg POS',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: IcebergTheme.vibrantRosePink,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Card container for the PIN area
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 40,
                      vertical: isMobile ? 32 : 40,
                    ),
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: isMobile
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 30,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        if (!isMobile) ...[
                          Text(
                            'Welcome back',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: IcebergTheme.darkSlate,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          'Enter your 4-digit PIN',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // PIN dots
                        _buildPinDots(),
                        const SizedBox(height: 12),

                        // Error message
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _error != null
                              ? Container(
                                  key: const ValueKey('error'),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFDC2626),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _error!,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFFDC2626),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  key: ValueKey('no-error'), height: 16),
                        ),
                        const SizedBox(height: 16),

                        // Numpad
                        _buildNumpad(isMobile),

                        // Loading indicator
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isLoading
                              ? Padding(
                                  key: const ValueKey('loading'),
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      strokeCap: StrokeCap.round,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        IcebergTheme.vibrantRosePink,
                                      ),
                                      backgroundColor: IcebergTheme.creamPink
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('not-loading')),
                        ),
                      ],
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

  // ──────────────────────────────────────────────
  //  PIN dots
  // ──────────────────────────────────────────────
  Widget _buildPinDots() {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final progress = _shakeController.value;
        final offset = progress < 1.0
            ? 10 *
                (0.5 - progress).abs() *
                (progress < 0.5 ? 1 : -1)
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
          return SizedBox(
            width: 38,
            height: 20,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: isFilled ? 16 : 14,
                height: isFilled ? 16 : 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? (_error != null
                          ? const Color(0xFFDC2626)
                          : IcebergTheme.vibrantRosePink)
                      : Colors.transparent,
                  border: Border.all(
                    color: _error != null
                        ? const Color(0xFFDC2626)
                        : isFilled
                            ? IcebergTheme.vibrantRosePink
                            : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: isFilled
                      ? [
                          BoxShadow(
                            color: (_error != null
                                    ? const Color(0xFFDC2626)
                                    : IcebergTheme.vibrantRosePink)
                                .withValues(alpha: 0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Number pad
  // ──────────────────────────────────────────────
  Widget _buildNumpad(bool isMobile) {
    final buttonSize = isMobile ? 64.0 : 72.0;

    return SizedBox(
      width: isMobile ? 260 : 300,
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var j = 1; j <= 3; j++)
                    _buildNumPadButton(
                      '${(i * 3) + j}',
                      size: buttonSize,
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: buttonSize),
                _buildNumPadButton('0', size: buttonSize),
                _buildActionButton(
                  Icons.backspace_outlined,
                  onPressed: _onDeletePressed,
                  size: buttonSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumPadButton(String text, {required double size}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () => _onDigitPressed(text),
          splashColor: IcebergTheme.vibrantRosePink.withValues(alpha: 0.1),
          highlightColor: IcebergTheme.creamPink.withValues(alpha: 0.3),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFAFAFA),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: IcebergTheme.darkSlate,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon, {
    required VoidCallback onPressed,
    required double size,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          splashColor: Colors.grey.withValues(alpha: 0.1),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: 22,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
