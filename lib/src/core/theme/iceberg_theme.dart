import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IcebergTheme {
  static const Color mintBlue = Color(0xFFE2F0CB);
  static const Color mintBlueDark = Color(0xFFB1D888);
  static const Color creamPink = Color(0xFFFDE8EC);      // Light red tint
  static const Color creamPinkDark = Color(0xFFF0A3B3);   // Mid red tint
  static const Color vibrantRosePink = Color(0xFFE8384F); // Poster coral-red
  static const Color darkSlate = Color(0xFF2C2C2C);       // Near-black text
  static const Color lightGrey = Color(0xFFF8F9FA);       // Subtle off-white
  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: vibrantRosePink,
        primary: vibrantRosePink,
        onPrimary: white,
        primaryContainer: creamPink,
        onPrimaryContainer: darkSlate,
        secondary: mintBlue,
        onSecondary: darkSlate,
        secondaryContainer: mintBlueDark,
        surface: white,
        onSurface: darkSlate,
        surfaceContainerHighest: lightGrey,
      ),
      scaffoldBackgroundColor: white,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold, color: darkSlate, fontSize: 32),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold, color: darkSlate, fontSize: 28),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: darkSlate, fontSize: 24),
        headlineMedium: baseTextTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: darkSlate),
        titleLarge: baseTextTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w600, color: darkSlate),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: darkSlate),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: darkSlate),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: creamPink.withValues(alpha: 0.5), width: 1),
        ),
        color: white,
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantRosePink,
          foregroundColor: white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: vibrantRosePink,
          side: const BorderSide(color: vibrantRosePink, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: white,
        selectedIconTheme: IconThemeData(color: vibrantRosePink),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelTextStyle:
            TextStyle(color: vibrantRosePink, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: TextStyle(color: Colors.grey),
        useIndicator: true,
        indicatorColor: creamPink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: white,
        indicatorColor: creamPink,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: vibrantRosePink, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: Colors.grey);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: vibrantRosePink);
          }
          return const IconThemeData(color: Colors.grey);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: vibrantRosePink, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: vibrantRosePink,
          foregroundColor: white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
