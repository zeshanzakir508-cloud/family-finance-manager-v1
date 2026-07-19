// lib/presentation/widgets/animations/app_fade.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A fade animation widget.
///
/// This widget provides a standardized fade animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppFade(
///   child: Text('Hello'),
///   duration: Duration(milliseconds: 300),
/// )
/// ```
class AppFade extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The delay before the animation starts.
  final Duration? delay;

  /// Creates a new [AppFade].
  const AppFade({
    super.key,
    required this.child,
    this.visible = true,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.delay,
  });

  @override
  State<AppFade> createState() => _AppFadeState();
}

class _AppFadeState extends State<AppFade> with SingleTickerProviderStateMixin {
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
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve.value,
    );
    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AppFade oldWidget) {
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
    if (widget.delay != null && widget.delay!.inMilliseconds > 0) {
      return FutureBuilder(
        future: Future.delayed(widget.delay!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return FadeTransition(
            opacity: _animation,
            child: widget.child,
          );
        },
      );
    }

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
