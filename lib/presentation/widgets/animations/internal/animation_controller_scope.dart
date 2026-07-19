// lib/presentation/widgets/animations/internal/animation_controller_scope.dart

import 'package:flutter/material.dart';

/// Internal widget for providing animation controller scope.
class AnimationControllerScope extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimationControllerScope({
    super.key,
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<AnimationControllerScope> createState() =>
      _AnimationControllerScopeState();
}

class _AnimationControllerScopeState extends State<AnimationControllerScope>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimationControllerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
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
      builder: (context, child) => child!,
      child: widget.child,
    );
  }
}
