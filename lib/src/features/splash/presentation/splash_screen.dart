import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/iceberg_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Fade + scale in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutBack,
      ),
    );

    // Subtle pulse after the logo appears
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Small delay before starting
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Play fade + scale in
    _fadeController.forward();

    // After fade-in completes, do a gentle pulse
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    _pulseController.repeat(reverse: true);

    // Wait then navigate
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    _navigateToLogin();
  }

  void _navigateToLogin() {
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/iceberg_logo.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  // M3 expressive loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        strokeCap: StrokeCap.round,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          IcebergTheme.vibrantRosePink,
                        ),
                        backgroundColor:
                            IcebergTheme.creamPink.withValues(alpha: 0.6),
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
}
