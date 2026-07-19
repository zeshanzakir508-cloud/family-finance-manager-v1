// lib/presentation/widgets/animations/internal/transition_builder.dart

import 'package:flutter/material.dart';

import '../enums/transition_type.dart';
import '../helpers/transition_style_builder.dart';

/// Internal widget for building transitions.
class TransitionBuilder extends StatelessWidget {
  final Widget child;
  final TransitionStyle style;
  final Animation<double> animation;

  const TransitionBuilder({
    super.key,
    required this.child,
    required this.style,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    switch (style.type) {
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
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: style.curve,
            ),
          ),
          child: child,
        );

      case TransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child,
        );

      case TransitionType.none:
        return child;
    }
  }
}
