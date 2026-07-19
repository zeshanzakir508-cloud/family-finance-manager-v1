// lib/presentation/widgets/animations/app_rotation.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A rotation animation widget.
///
/// This widget provides a standardized rotation animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppRotation(
///   child: Icon(Icons.refresh),
///   turns: 1.0,
/// )
/// ```
class AppRotation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// The number of full rotations.
  final double turns;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// Whether to repeat the animation.
  final bool repeat;

  /// Creates a new [AppRotation].
  const AppRotation({
    super.key,
    required this.child,
    this.visible = true,
    this.turns = 1.0,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.repeat = false,
  });

  @override
  State<AppRotation> createState() => _AppRotationState();
}

class _AppRotationState extends State<AppRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? widget.speed.duration;
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.turns).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve.value,
      ),
    );
    if (widget.visible) {
      _controller.forward();
      if (widget.repeat) {
        _controller.repeat();
      }
    }
  }

  @override
  void didUpdateWidget(AppRotation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      if (widget.visible) {
        _controller.forward();
        if (widget.repeat) {
          _controller.repeat();
        }
      } else {
        _controller.stop();
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
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}
