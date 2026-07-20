// lib/presentation/templates/internal/page_scaffold.dart

import 'package:flutter/material.dart';

import '../helpers/page_style_builder.dart';

/// Internal widget for page scaffold.
class PageScaffold extends StatelessWidget {
  final Widget body;
  final PageStyle style;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final EdgeInsets? padding;

  const PageScaffold({
    super.key,
    required this.body,
    required this.style,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: appBar as PreferredSizeWidget?,
      body: SafeArea(
        child: Padding(
          padding: padding ?? style.padding,
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
