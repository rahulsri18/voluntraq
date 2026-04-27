import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF059669); // Emerald 600
  static const Color primaryLight = Color(0xFF34D399); // Emerald 400
  static const Color secondary = Color(0xFF10B981); // Emerald 500
  static const Color background = Color(0xFFF0FDF4); // Green 50 (Light tint)
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF064E3B); // Very dark green for text
  static const Color textSecondary = Color(0xFF065F46); // Dark green for secondary text
  
  static const Color critical = Color(0xFFDC2626); // Red
  static const Color high = Color(0xFFEA580C); // Orange
  static const Color medium = Color(0xFFD97706); // Yellow-ish
  static const Color low = Color(0xFF059669); // Green
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF065F46), Color(0xFF10B981)], // Deep Green to Bright Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
