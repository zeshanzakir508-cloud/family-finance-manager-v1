// lib/presentation/widgets/layout/internal/section_footer.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering section footer.
class SectionFooter extends StatelessWidget {
  final Widget? child;

  const SectionFooter({
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
