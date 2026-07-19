// lib/presentation/widgets/animations/app_slide.dart

import 'package:flutter/material.dart';

import 'enums/animation_curve.dart';
import 'enums/animation_speed.dart';
import 'enums/animation_direction.dart';
import 'helpers/animation_style_builder.dart';

/// A slide animation widget.
///
/// This widget provides a standardized slide animation that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSlide(
///   child: Text('Hello'),
///   direction: AnimationDirection.fromBottom,
///   offset: 50,
/// )
/// ```
class AppSlide extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether the child should be visible.
  final bool visible;

  /// The direction of the slide.
  final AnimationDirection direction;

  /// The offset distance in pixels.
  final double offset;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final AnimationCurve curve;

  /// The animation speed.
  final AnimationSpeed speed;

  /// The delay before the animation starts.
  final Duration? delay;

  /// Creates a new [AppSlide].
  const AppSlide({
    super.key,
    required this.child,
    this.visible = true,
    this.direction = AnimationDirection.fromBottom,
    this.offset = 50,
    this.duration,
    this.curve = AnimationCurve.easeInOut,
    this.speed = AnimationSpeed.normal,
    this.delay,
  });

  @override
  State<AppSlide> createState() => _AppSlideState();
}

class _AppSlideState extends State<AppSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? widget.speed.duration;
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    _animation = _getTween().animate(
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
  void didUpdateWidget(AppSlide oldWidget) {
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

  Tween<Offset> _getTween() {
    final offset = widget.offset;
    switch (widget.direction) {
      case AnimationDirection.fromTop:
        return Tween<Offset>(
          begin: Offset(0, -offset),
          end: Offset.zero,
        );
      case AnimationDirection.fromBottom:
        return Tween<Offset>(
          begin: Offset(0, offset),
          end: Offset.zero,
        );
      case AnimationDirection.fromLeft:
        return Tween<Offset>(
          begin: Offset(-offset, 0),
          end: Offset.zero,
        );
      case AnimationDirection.fromRight:
        return Tween<Offset>(
          begin: Offset(offset, 0),
          end: Offset.zero,
        );
      case AnimationDirection.fromCenter:
        return Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        );
      case AnimationDirection.toCenter:
        return Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        );
    }
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
          return SlideTransition(
            position: _animation,
            child: widget.child,
          );
        },
      );
    }

    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
