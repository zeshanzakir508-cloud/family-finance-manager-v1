// lib/presentation/widgets/overlays/internal/overlay_container.dart

import 'package:flutter/material.dart';

import '../helpers/overlay_style_builder.dart';

/// Internal widget for rendering overlay container.
class OverlayContainer extends StatelessWidget {
  final Widget child;
  final OverlayStyle style;
  final EdgeInsets? padding;

  const OverlayContainer({
    super.key,
    required this.child,
    required this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
