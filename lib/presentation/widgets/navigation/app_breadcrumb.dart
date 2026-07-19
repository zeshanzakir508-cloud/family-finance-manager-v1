// lib/presentation/widgets/navigation/app_breadcrumb.dart

import 'package:flutter/material.dart';

import 'enums/navigation_variant.dart';
import 'enums/navigation_size.dart';
import 'helpers/navigation_style_builder.dart';

/// A breadcrumb navigation widget.
///
/// This widget provides a standardized breadcrumb trail that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppBreadcrumb(
///   items: const [
///     BreadcrumbItem(label: 'Home', onTap: () => navigateToHome()),
///     BreadcrumbItem(label: 'Settings', onTap: () => navigateToSettings()),
///     BreadcrumbItem(label: 'Profile'),
///   ],
/// )
/// ```
class AppBreadcrumb extends StatelessWidget {
  /// The breadcrumb items to display.
  final List<BreadcrumbItem> items;

  /// The separator between items.
  final Widget? separator;

  /// The visual variant of the breadcrumb.
  final NavigationVariant variant;

  /// The size of the breadcrumb.
  final NavigationSize size;

  /// Custom text color override.
  final Color? color;

  /// Creates a new [AppBreadcrumb].
  const AppBreadcrumb({
    super.key,
    required this.items,
    this.separator,
    this.variant = NavigationVariant.surface,
    this.size = NavigationSize.medium,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = NavigationStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
    );

    final fgColor = color ?? style.foregroundColor;

    final children = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      children.add(
        _BreadcrumbItemWidget(
          item: item,
          isLast: isLast,
          color: fgColor,
          style: style,
        ),
      );

      if (!isLast) {
        children.add(
          separator ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: fgColor.withOpacity(0.4),
                ),
              ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

/// A breadcrumb item.
class BreadcrumbItem {
  /// The label of the item.
  final String label;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Creates a new [BreadcrumbItem].
  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

/// Internal widget for a breadcrumb item.
class _BreadcrumbItemWidget extends StatelessWidget {
  final BreadcrumbItem item;
  final bool isLast;
  final Color color;
  final NavigationStyle style;

  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
    required this.color,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isClickable = item.onTap != null && !isLast;

    final child = Text(
      item.label,
      style: style.labelStyle.copyWith(
        color: isLast ? color : color.withOpacity(0.6),
        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
      ),
    );

    if (isClickable) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: child,
    );
  }
}
