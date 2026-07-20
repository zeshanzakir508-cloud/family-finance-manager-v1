// lib/presentation/templates/internal/page_header.dart

import 'package:flutter/material.dart';

/// Internal widget for page header.
class PageHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final double spacing;

  const PageHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.spacing,
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              if (hasTitle && hasSubtitle)
                const SizedBox(height: 2),
              if (hasSubtitle)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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
      padding: EdgeInsets.only(bottom: spacing),
      child: Row(
        children: children,
      ),
    );
  }
}
