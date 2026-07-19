// lib/presentation/widgets/animations/internal/animated_visibility.dart

import 'package:flutter/material.dart';

import '../enums/animation_curve.dart';
import '../enums/animation_speed.dart';
import '../helpers/animation_style_builder.dart';

/// Internal widget for animated visibility.
class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final AnimationStyle style;
  final Duration? delay;

  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    required this.style,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (delay != null && delay!.inMilliseconds > 0) {
      result = FutureBuilder(
        future: Future.delayed(delay!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return child;
        },
      );
    }

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: style.duration,
      curve: style.curve,
      child: result,
    );
  }
}
