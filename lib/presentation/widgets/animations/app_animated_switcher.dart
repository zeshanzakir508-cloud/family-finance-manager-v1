// lib/presentation/widgets/animations/app_animated_switcher.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'enums/transition_type.dart';
import 'helpers/animation_style_builder.dart';

/// An animated switcher with consistent styling.
///
/// This widget provides a standardized animated switcher that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppAnimatedSwitcher(
///   child: isVisible ? Container(color: Colors.blue) : Container(color: Colors.red),
///   transitionType: TransitionType.fade,
/// )
/// ```
class AppAnimatedSwitcher extends StatelessWidget {
  /// The child widget to switch.
  final Widget child;

  /// The duration of the animation.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The transition type.
  final TransitionType transitionType;

  /// Whether to reverse the animation.
  final bool reverse;

  /// Creates a new [AppAnimatedSwitcher].
  const AppAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.transitionType = TransitionType.fade,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = duration ?? speed.duration;

    return AnimatedSwitcher(
      duration: effectiveDuration,
      reverseDuration: reverse ? effectiveDuration : null,
      switchInCurve: curve.value,
      switchOutCurve: curve.value,
      transitionBuilder: (child, animation) {
        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );

          case TransitionType.scale:
            return ScaleTransition(
              scale: animation,
              child: child,
            );

          case TransitionType.slideBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case TransitionType.slideTop:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.25),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case TransitionType.slideRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.25, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case TransitionType.slideLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.25, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case TransitionType.zoom:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve.value,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );

          case TransitionType.rotation:
            return RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            );

          case TransitionType.none:
            return child;
        }
      },
      child: child,
    );
  }
}
