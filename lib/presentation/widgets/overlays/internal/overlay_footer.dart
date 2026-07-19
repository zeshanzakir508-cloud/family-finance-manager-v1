// lib/presentation/widgets/overlays/internal/overlay_footer.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering overlay footer.
class OverlayFooter extends StatelessWidget {
  final Widget? child;

  const OverlayFooter({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: child!,
    );
  }
}
