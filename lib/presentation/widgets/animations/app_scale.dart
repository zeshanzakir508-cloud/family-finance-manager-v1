// lib/presentation/widgets/animations/app_scale.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'helpers/animation_style_builder.dart';

/// A scale animation widget.
///
/// This widget provides a standardized scale animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppScale(
///   child: Text('Hello'),
///   begin: 0.5,
///   end: 1.0,
/// )
/// ```
class AppScale extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// The beginning scale value.
  final double begin;

  /// The ending scale value.
  final double end;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The delay before the animation starts.
  final Duration? delay;

  /// Creates a new [AppScale].
  const AppScale({
    super.key,
    required this.child,
    this.visible = true,
    this.begin = 0.5,
    this.end = 1.0,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.delay,
  });

  @override
  State<AppScale> createState() => _AppScaleState();
}

class _AppScaleState extends State<AppScale> with SingleTickerProviderStateMixin {
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
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
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
  void didUpdateWidget(AppScale oldWidget) {
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
          return ScaleTransition(
            scale: _animation,
            child: widget.child,
          );
        },
      );
    }

    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
