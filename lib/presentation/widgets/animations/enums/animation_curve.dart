// lib/presentation/widgets/animations/enums/animation_curve.dart

import 'package:flutter/material.dart';

/// Predefined animation curves for consistent motion.
enum AnimationCurve {
  /// Linear animation.
  linear,

  /// Ease in animation.
  easeIn,

  /// Ease out animation.
  easeOut,

  /// Ease in and out animation.
  easeInOut,

  /// Slow then fast then slow (spring-like).
  easeInOutCubic,

  /// Bounce effect at the end.
  bounceOut,

  /// Elastic effect at the end.
  elasticOut,

  /// Decelerate to zero.
  decelerate,

  /// Fast at start, slow at end.
  fastOutSlowIn;

  /// Returns the Flutter [Curve] for this enum value.
  Curve get value {
    switch (this) {
      case AnimationCurve.linear:
        return Curves.linear;
      case AnimationCurve.easeIn:
        return Curves.easeIn;
      case AnimationCurve.easeOut:
        return Curves.easeOut;
      case AnimationCurve.easeInOut:
        return Curves.easeInOut;
      case AnimationCurve.easeInOutCubic:
        return Curves.easeInOutCubic;
      case AnimationCurve.bounceOut:
        return Curves.bounceOut;
      case AnimationCurve.elasticOut:
        return Curves.elasticOut;
      case AnimationCurve.decelerate:
        return Curves.decelerate;
      case AnimationCurve.fastOutSlowIn:
        return Curves.fastOutSlowIn;
    }
  }
}
