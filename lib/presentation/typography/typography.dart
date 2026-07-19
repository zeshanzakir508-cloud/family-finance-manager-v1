// lib/presentation/typography/typography.dart

import 'package:flutter/material.dart';

/// Application-wide typography design tokens.
///
/// This class defines the core typography system including font families,
/// font sizes, font weights, letter spacing, and line heights.
/// It serves as the single source of truth for all typography values.
///
/// Example:
/// ```dart
/// final headlineSize = Typography.headlineLargeSize;
/// final bodyWeight = Typography.weightRegular;
/// ```
abstract final class Typography {
  // ---------------------------------------------------------------------------
  // Font Families
  // ---------------------------------------------------------------------------

  /// The primary font family used throughout the application.
  ///
  /// Set to null to use the platform default font.
  /// To use a custom font, specify the font family name here
  /// and add it to pubspec.yaml.
  static const String? fontFamily = null;

  /// Optional secondary font family for special use cases.
  static const String? fontFamilySecondary = null;

  // ---------------------------------------------------------------------------
  // Font Weights
  // ---------------------------------------------------------------------------

  /// Thin font weight (100).
  static const FontWeight weightThin = FontWeight.w100;

  /// Extra light font weight (200).
  static const FontWeight weightExtraLight = FontWeight.w200;

  /// Light font weight (300).
  static const FontWeight weightLight = FontWeight.w300;

  /// Regular font weight (400) - default.
  static const FontWeight weightRegular = FontWeight.w400;

  /// Medium font weight (500).
  static const FontWeight weightMedium = FontWeight.w500;

  /// Semi-bold font weight (600).
  static const FontWeight weightSemiBold = FontWeight.w600;

  /// Bold font weight (700).
  static const FontWeight weightBold = FontWeight.w700;

  /// Extra bold font weight (800).
  static const FontWeight weightExtraBold = FontWeight.w800;

  /// Black font weight (900).
  static const FontWeight weightBlack = FontWeight.w900;

  // ---------------------------------------------------------------------------
  // Font Sizes
  // ---------------------------------------------------------------------------

  /// Display large (57px).
  static const double displayLargeSize = 57;

  /// Display medium (45px).
  static const double displayMediumSize = 45;

  /// Display small (36px).
  static const double displaySmallSize = 36;

  /// Headline large (32px).
  static const double headlineLargeSize = 32;

  /// Headline medium (28px).
  static const double headlineMediumSize = 28;

  /// Headline small (24px).
  static const double headlineSmallSize = 24;

  /// Title large (22px).
  static const double titleLargeSize = 22;

  /// Title medium (16px).
  static const double titleMediumSize = 16;

  /// Title small (14px).
  static const double titleSmallSize = 14;

  /// Body large (16px).
  static const double bodyLargeSize = 16;

  /// Body medium (14px).
  static const double bodyMediumSize = 14;

  /// Body small (12px).
  static const double bodySmallSize = 12;

  /// Label large (14px).
  static const double labelLargeSize = 14;

  /// Label medium (12px).
  static const double labelMediumSize = 12;

  /// Label small (11px).
  static const double labelSmallSize = 11;

  // ---------------------------------------------------------------------------
  // Letter Spacing
  // ---------------------------------------------------------------------------

  /// Default letter spacing (0).
  static const double letterSpacingNone = 0;

  /// Tight letter spacing (-0.5).
  static const double letterSpacingTight = -0.5;

  /// Loose letter spacing (0.5).
  static const double letterSpacingLoose = 0.5;

  /// Wider letter spacing (1.0).
  static const double letterSpacingWide = 1.0;

  /// Extra wide letter spacing (1.5).
  static const double letterSpacingExtraWide = 1.5;

  // ---------------------------------------------------------------------------
  // Line Heights
  // ---------------------------------------------------------------------------

  /// Tight line height (1.0).
  static const double lineHeightTight = 1.0;

  /// Normal line height (1.2).
  static const double lineHeightNormal = 1.2;

  /// Relaxed line height (1.5).
  static const double lineHeightRelaxed = 1.5;

  /// Loose line height (1.8).
  static const double lineHeightLoose = 1.8;
}
