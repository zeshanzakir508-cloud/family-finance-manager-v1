import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// ============================================================================
/// Family Finance Manager
/// App Theme
/// ----------------------------------------------------------------------------
/// Central entry point for application themes.
///
/// Do NOT import LightTheme or DarkTheme anywhere else.
/// Always use AppTheme.
/// ============================================================================

class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData get light => LightTheme.theme;

  /// Dark Theme
  static ThemeData get dark => DarkTheme.theme;
}
