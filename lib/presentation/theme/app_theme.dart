// lib/presentation/theme/app_theme.dart

import 'package:flutter/material.dart';

import 'light_theme.dart';
import 'theme_constants.dart';

/// The application's main theme configuration entry point.
///
/// This class serves as a thin facade that delegates to specialized theme
/// implementations. It provides a clean, unified interface for accessing
/// all theme configurations throughout the application.
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   home: MyHomePage(),
/// )
/// ```
abstract final class AppTheme {
  /// Light theme configuration for the application.
  ///
  /// This theme uses a light color scheme with Material Design 3 principles,
  /// suitable for most use cases and providing optimal readability.
  static ThemeData get light => LightTheme.build();

  /// Dark theme configuration for the application.
  ///
  /// This theme uses a dark color scheme optimized for low-light environments,
  /// reducing eye strain while maintaining readability and visual hierarchy.
  static ThemeData get dark => LightTheme.buildDark(); // or DarkTheme.build()
}
