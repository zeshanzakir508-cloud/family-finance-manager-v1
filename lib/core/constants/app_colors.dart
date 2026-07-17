import 'package:flutter/material.dart';

/// ============================================================================
/// Family Finance Manager
/// App Colors
/// ============================================================================

class AppColors {
  AppColors._();

  //--------------------------------------------------------------------------
  // Brand
  //--------------------------------------------------------------------------

  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF002171);

  static const Color secondary = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF26A69A);
  static const Color secondaryDark = Color(0xFF00695C);

  //--------------------------------------------------------------------------
  // Background
  //--------------------------------------------------------------------------

  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Colors.white;
  static const Color surface = Colors.white;

  //--------------------------------------------------------------------------
  // Text
  //--------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  //--------------------------------------------------------------------------
  // Status
  //--------------------------------------------------------------------------

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  //--------------------------------------------------------------------------
  // Transactions
  //--------------------------------------------------------------------------

  static const Color income = success;
  static const Color expense = error;
  static const Color transfer = primary;

  //--------------------------------------------------------------------------
  // UI
  //--------------------------------------------------------------------------

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x14000000);

  //--------------------------------------------------------------------------
  // Misc
  //--------------------------------------------------------------------------

  static const Color transparent = Colors.transparent;
}
