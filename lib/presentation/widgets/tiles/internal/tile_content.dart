// lib/presentation/widgets/tiles/internal/tile_content.dart

import 'package:flutter/material.dart';

import '../helpers/tile_style_builder.dart';
import 'tile_row.dart';

/// Internal widget for tile content.
class TileContent extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final Widget? child;
  final TileStyle style;
  final Color fgColor;

  const TileContent({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.child,
    required this.style,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitleSubtitle = title != null || subtitle != null;
    final hasLeading = leading != null;
    final hasTrailing = trailing != null;
    final hasChild = child != null;
    final hasFooter = footer != null;

    if (!hasLeading && !hasTitleSubtitle && !hasTrailing && !hasChild && !hasFooter) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    // Main row: leading | title/subtitle | trailing
    if (hasLeading || hasTitleSubtitle || hasTrailing) {
      children.add(
        TileRow(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          style: style,
          fgColor: fgColor,
        ),
      );
    }

    // Child
    if (hasChild) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: style.contentSpacing));
      }
      children.add(child!);
    }

    // Footer
    if (hasFooter) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: style.contentSpacing * 0.5));
      }
      children.add(
        DefaultTextStyle(
          style: style.subtitleStyle,
          child: footer!,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
