// lib/presentation/templates/helpers/page_layout_builder.dart

import 'package:flutter/material.dart';

import '../enums/page_density.dart';

/// Helper class for building page layouts.
///
/// This class provides methods for building consistent page layouts.
///
/// Example:
/// ```dart
/// final layout = PageLayoutBuilder.build(
///   context: context,
///   header: header,
///   body: body,
///   footer: footer,
/// );
/// ```
abstract final class PageLayoutBuilder {
  /// Builds a page layout with the given components.
  static Widget build({
    required BuildContext context,
    required Widget body,
    Widget? header,
    Widget? footer,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    PageDensity density = PageDensity.comfortable,
  }) {
    final children = <Widget>[];

    if (header != null) {
      children.add(header);
    }

    children.add(body);

    if (footer != null) {
      children.add(footer);
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );

    return Scaffold(
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
