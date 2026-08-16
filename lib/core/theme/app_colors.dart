import 'package:flutter/material.dart';

/// Centralized, anxiety-reducing color tokens for Pravāha.
/// Carefully curated with soft teals, warm slates, soothing sage, and gentle surfaces.
abstract final class AppColors {
  AppColors._();

  // Primary brand palette (Serene Deep Teal)
  static const Color primary = Color(0xFF006A6A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF6FF7F5);
  static const Color onPrimaryContainer = Color(0xFF002020);

  // Secondary palette (Calm Sage / Slate)
  static const Color secondary = Color(0xFF4A6363);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCCE8E7);
  static const Color onSecondaryContainer = Color(0xFF051F1F);

  // Accent & Biofeedback states (Supportive, non-harsh)
  static const Color accentTeal = Color(0xFF00A896);
  static const Color accentAmber = Color(0xFFE08D2A);
  static const Color accentCoral = Color(0xFFE26D5C);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color accentBlue = Color(0xFF0288D1);

  // Surfaces & Backgrounds (Crisp, modern, airy)
  static const Color background = Color(0xFFF6F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFDAE5E4);
  static const Color outline = Color(0xFF6F7979);
  static const Color outlineVariant = Color(0xFFBEC9C8);

  // Text & Content
  static const Color textPrimary = Color(0xFF161D1D);
  static const Color textSecondary = Color(0xFF3F4948);
  static const Color textTertiary = Color(0xFF6F7979);

  // Technique Card Gradients
  static const LinearGradient pacerGradient = LinearGradient(
    colors: [Color(0xFF006A6A), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient breathGradient = LinearGradient(
    colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient scenarioGradient = LinearGradient(
    colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient confidenceGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFFB8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
