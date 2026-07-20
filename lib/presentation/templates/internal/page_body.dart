// lib/presentation/templates/internal/page_body.dart

import 'package:flutter/material.dart';

import '../enums/page_scroll_behavior.dart';

/// Internal widget for page body.
class PageBody extends StatelessWidget {
  final Widget child;
  final PageScrollBehavior scrollBehavior;
  final EdgeInsets? padding;

  const PageBody({
    super.key,
    required this.child,
    required this.scrollBehavior,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollBehavior == PageScrollBehavior.none) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
    }

    return Expanded(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: _buildScrollView(),
      ),
    );
  }

  Widget _buildScrollView() {
    switch (scrollBehavior) {
      case PageScrollBehavior.none:
        return child;
      case PageScrollBehavior.normal:
        return SingleChildScrollView(
          child: child,
        );
      case PageScrollBehavior.reverse:
        return SingleChildScrollView(
          reverse: true,
          child: child,
        );
      case PageScrollBehavior.paged:
        // For paged scrolling, we use a ListView with a builder
        // This is a simplified version; actual paging would need more logic
        return ListView(
          children: [child],
        );
    }
  }
}
