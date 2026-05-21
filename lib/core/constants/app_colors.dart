import 'package:flutter/material.dart';

/// Centralized color palette for the Laundry App.
class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);

  // Background
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Accent
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Auth-specific gradients
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  static const List<Color> splashGradient = [
    Color(0xFF1E40AF),
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  // Neutral
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color shadow = Color(0x0A000000);

  // Social
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);

  // Password strength
  static const Color strengthWeak = Color(0xFFEF4444);
  static const Color strengthMedium = Color(0xFFF59E0B);
  static const Color strengthStrong = Color(0xFF10B981);
}
