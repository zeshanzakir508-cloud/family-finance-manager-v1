// lib/presentation/widgets/animations/app_size_animation.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A size animation widget.
///
/// This widget provides a standardized size animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSizeAnimation(
///   child: Container(width: 100, height: 100),
///   begin: Size(50, 50),
///   end: Size(200, 200),
/// )
/// ```
class AppSizeAnimation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// The beginning size.
  final Size begin;

  /// The ending size.
  final Size end;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// Creates a new [AppSizeAnimation].
  const AppSizeAnimation({
    super.key,
    required this.child,
    this.visible = true,
    required this.begin,
    required this.end,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
  });

  @override
  State<AppSizeAnimation> createState() => _AppSizeAnimationState();
}

class _AppSizeAnimationState extends State<AppSizeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Size> _animation;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? widget.speed.duration;
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    _animation = SizeTween(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve.value,
      ),
    );
    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AppSizeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: _animation.value.width,
          height: _animation.value.height,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
