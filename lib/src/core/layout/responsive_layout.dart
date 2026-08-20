import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // ── Breakpoints ──
  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 360;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width > 768 &&
      MediaQuery.sizeOf(context).width <= 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width > 1200;

  /// Returns a value based on the current screen size.
  /// Useful for adaptive padding, font sizes, aspect ratios, etc.
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? smallPhone,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= 360 && smallPhone != null) return smallPhone;
    if (width <= 768) return mobile;
    if (width <= 1200) return tablet ?? desktop ?? mobile;
    return desktop ?? mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return desktop;
        } else if (constraints.maxWidth <= 1200 && constraints.maxWidth > 768) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
