// lib/presentation/widgets/animations/helpers/animation_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/animation_curve.dart';
import '../enums/animation_speed.dart';

/// Builder class for creating consistent animation styles.
///
/// This class constructs [AnimationStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for animation styling.
///
/// Example:
/// ```dart
/// final style = AnimationStyleBuilder.build(
///   curve: AnimationCurve.easeInOut,
///   speed: AnimationSpeed.normal,
/// );
/// ```
abstract final class AnimationStyleBuilder {
  /// Builds an [AnimationStyle] configuration with the given parameters.
  static AnimationStyle build({
    required AnimationCurve curve,
    required AnimationSpeed speed,
  }) {
    return AnimationStyle(
      curve: curve.value,
      duration: speed.duration,
    );
  }

  /// Builds an [AnimationStyle] with custom parameters.
  static AnimationStyle buildCustom({
    required Curve curve,
    required Duration duration,
  }) {
    return AnimationStyle(
      curve: curve,
      duration: duration,
    );
  }
}

/// Style configuration for animations.
@immutable
class AnimationStyle {
  /// The animation curve.
  final Curve curve;

  /// The animation duration.
  final Duration duration;

  /// Creates a new [AnimationStyle].
  const AnimationStyle({
    required this.curve,
    required this.duration,
  });
}
