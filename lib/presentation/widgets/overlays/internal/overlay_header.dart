// lib/presentation/widgets/overlays/internal/overlay_header.dart

import 'package:flutter/material.dart';

import '../helpers/overlay_style_builder.dart';

/// Internal widget for rendering overlay header.
class OverlayHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final OverlayStyle style;

  const OverlayHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final hasLeading = leading != null;
    final hasTrailing = trailing != null;

    if (!hasTitle && !hasSubtitle && !hasLeading && !hasTrailing) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    if (hasLeading) {
      children.add(leading!);
      children.add(const SizedBox(width: 12));
    }

    if (hasTitle || hasSubtitle) {
      children.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasTitle)
                Text(
                  title!,
                  style: style.titleStyle,
                ),
              if (hasTitle && hasSubtitle)
                const SizedBox(height: 2),
              if (hasSubtitle)
                Text(
                  subtitle!,
                  style: style.subtitleStyle,
                ),
            ],
          ),
        ),
      );
    }

    if (hasTrailing) {
      children.add(const SizedBox(width: 12));
      children.add(trailing!);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: children,
      ),
    );
  }
}
