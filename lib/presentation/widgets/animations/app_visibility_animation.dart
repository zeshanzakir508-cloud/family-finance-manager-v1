// lib/presentation/widgets/animations/app_visibility_animation.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A visibility animation widget that combines fade and scale.
///
/// This widget provides a standardized visibility animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppVisibilityAnimation(
///   visible: isVisible,
///   child: Text('Hello'),
///   fadeOnly: true,
/// )
/// ```
class AppVisibilityAnimation extends StatelessWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// Whether to use fade only (no scale).
  final bool fadeOnly;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The scale amount when hidden.
  final double scaleEnd;

  /// Creates a new [AppVisibilityAnimation].
  const AppVisibilityAnimation({
    super.key,
    required this.child,
    required this.visible,
    this.fadeOnly = false,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.scaleEnd = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = duration ?? speed.duration;

    return AnimatedVisibility(
      visible: visible,
      duration: effectiveDuration,
      curve: curve.value,
      child: child,
    );
  }
}
