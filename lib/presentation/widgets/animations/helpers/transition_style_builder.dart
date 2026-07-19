// lib/presentation/widgets/animations/helpers/transition_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/transition_type.dart';
import '../enums/animation_curve.dart';
import '../enums/animation_speed.dart';

/// Builder class for creating consistent transition styles.
///
/// This class constructs [TransitionStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for transition styling.
///
/// Example:
/// ```dart
/// final style = TransitionStyleBuilder.build(
///   type: TransitionType.fade,
///   curve: AnimationCurve.easeInOut,
///   speed: AnimationSpeed.normal,
/// );
/// ```
abstract final class TransitionStyleBuilder {
  /// Builds a [TransitionStyle] configuration with the given parameters.
  static TransitionStyle build({
    required TransitionType type,
    required AnimationCurve curve,
    required AnimationSpeed speed,
  }) {
    return TransitionStyle(
      type: type,
      curve: curve.value,
      duration: speed.duration,
    );
  }
}

/// Style configuration for transitions.
@immutable
class TransitionStyle {
  /// The transition type.
  final TransitionType type;

  /// The animation curve.
  final Curve curve;

  /// The animation duration.
  final Duration duration;

  /// Creates a new [TransitionStyle].
  const TransitionStyle({
    required this.type,
    required this.curve,
    required this.duration,
  });
}
