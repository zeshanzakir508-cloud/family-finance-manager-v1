// lib/presentation/widgets/animations/app_staggered_animation.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A staggered animation widget for animating multiple children sequentially.
///
/// This widget provides a standardized staggered animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppStaggeredAnimation(
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
///   staggerDelay: 100,
/// )
/// ```
class AppStaggeredAnimation extends StatefulWidget {
  /// The children widgets to animate.
  final List<Widget> children;

  /// The delay between each child's animation start.
  final Duration staggerDelay;

  /// The animation duration for each child.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The direction of the stagger.
  final Axis direction;

  /// Creates a new [AppStaggeredAnimation].
  const AppStaggeredAnimation({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.direction = Axis.vertical,
  });

  @override
  State<AppStaggeredAnimation> createState() => _AppStaggeredAnimationState();
}

class _AppStaggeredAnimationState extends State<AppStaggeredAnimation> {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? widget.speed.duration;
    _controllers = List.generate(
      widget.children.length,
      (index) {
        final controller = AnimationController(
          duration: duration,
          vsync: this,
        );
        final animation = CurvedAnimation(
          parent: controller,
          curve: widget.curve.value,
        );
        _animations.add(animation);
        return controller;
      },
    );

    // Start staggered animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.direction == Axis.horizontal) {
      return Row(
        children: _buildChildren(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    return List.generate(widget.children.length, (index) {
      return AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Opacity(
            opacity: _animations[index].value,
            child: Transform.scale(
              scale: _animations[index].value,
              child: child,
            ),
          );
        },
        child: widget.children[index],
      );
    });
  }
}
