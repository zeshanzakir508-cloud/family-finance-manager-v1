// lib/presentation/widgets/animations/internal/animation_wrapper.dart

import 'package:flutter/material.dart';

import '../helpers/animation_style_builder.dart';

/// Internal widget for wrapping animations.
class AnimationWrapper extends StatelessWidget {
  final Widget child;
  final AnimationStyle style;
  final Animation<double> animation;

  const AnimationWrapper({
    super.key,
    required this.child,
    required this.style,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => child!,
      child: child,
    );
  }
}
