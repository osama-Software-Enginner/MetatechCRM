import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Brand Colors
  static const MaterialColor brand = MaterialColor(
    _brandPrimaryValue,
    <int, Color>{
      50: Color(0xFFF0F5FF),
      100: Color(0xFFE0ECFF),
      200: Color(0xFFBDD3F9),
      300: Color(0xFF81ACF9),
      400: Color(0xFF5A93F9),
      500: Color(_brandPrimaryValue), // Primary brand color
      600: Color(0xFF1559D1),
      700: Color(0xFF174EAF),
      800: Color(0xFF1D4387),
      900: Color(0xFF163367),
    },
  );
  static const int _brandPrimaryValue = 0xFF347AF6;

  // Surface and Background
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF9FAFB);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C2526); // Dark color for primary text
  static const Color textSecondary = Color(0xFF6B7280); // Lighter color for secondary text
  static const Color textDisabled = Color(0xFFB0B6BC); // Disabled text color

  // Semantic Colors
  static const Color error = Color(0xFFF44336); // Red for errors
  static const Color success = Color(0xFF4CAF50); // Green for success
  static const Color warning = Color(0xFFFFC107); // Yellow for warnings

  // Additional UI Colors
  static const Color divider = Color(0xFFE5E7EB); // For dividers or borders
  static const Color shadow = Color(0x33000000); // Subtle shadow color
}