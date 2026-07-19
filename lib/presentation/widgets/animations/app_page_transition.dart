// lib/presentation/widgets/animations/app_page_transition.dart

import 'package:flutter/material.dart';

import 'enums/transition_type.dart';
import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/transition_style_builder.dart';
import 'internal/transition_builder.dart';

/// A page transition widget with consistent styling.
///
/// This widget provides a standardized page transition that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   AppPageTransition(
///     child: MyPage(),
///     type: TransitionType.slideBottom,
///   ),
/// )
/// ```
class AppPageTransition extends PageRouteBuilder {
  /// The child widget to transition to.
  final Widget child;

  /// The transition type.
  final TransitionType type;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// Whether to maintain the previous widget's state.
  final bool maintainState;

  /// The duration of the transition.
  final Duration? duration;

  /// Creates a new [AppPageTransition].
  AppPageTransition({
    required this.child,
    this.type = TransitionType.fade,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.maintainState = true,
    this.duration,
  }) : super(
          transitionDuration: duration ?? speed.duration,
          reverseTransitionDuration:
              duration ?? speed.duration,
          pageBuilder: (context, animation, secondaryAnimation) => child,
          maintainState: maintainState,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final style = TransitionStyleBuilder.build(
              type: type,
              curve: curve,
              speed: speed,
            );

            return TransitionBuilder(
              child: child,
              style: style,
              animation: animation,
            );
          },
        );
}
