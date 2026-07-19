// lib/presentation/widgets/animations/helpers/duration_builder.dart

import 'package:flutter/material.dart';

import '../enums/animation_speed.dart';

/// Builder class for creating consistent animation durations.
///
/// This class provides centralized duration values for animations.
///
/// Example:
/// ```dart
/// final duration = DurationBuilder.build(AnimationSpeed.normal);
/// ```
abstract final class DurationBuilder {
  /// Returns the duration for the given speed.
  static Duration build(AnimationSpeed speed) {
    return speed.duration;
  }

  /// Returns a short duration for quick interactions.
  static Duration get short => const Duration(milliseconds: 150);

  /// Returns a medium duration for standard animations.
  static Duration get medium => const Duration(milliseconds: 300);

  /// Returns a long duration for complex animations.
  static Duration get long => const Duration(milliseconds: 500);

  /// Returns an extra long duration for elaborate animations.
  static Duration get extraLong => const Duration(milliseconds: 800);

  /// Returns a page transition duration.
  static Duration get pageTransition => const Duration(milliseconds: 350);

  /// Returns a dialog transition duration.
  static Duration get dialogTransition => const Duration(milliseconds: 250);

  /// Returns a snackbar duration.
  static Duration get snackbar => const Duration(milliseconds: 400);
}
