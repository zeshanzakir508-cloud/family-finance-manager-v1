// lib/presentation/templates/internal/page_footer.dart

import 'package:flutter/material.dart';

/// Internal widget for page footer.
class PageFooter extends StatelessWidget {
  final Widget child;
  final double spacing;

  const PageFooter({
    super.key,
    required this.child,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: spacing),
      child: child,
    );
  }
}
