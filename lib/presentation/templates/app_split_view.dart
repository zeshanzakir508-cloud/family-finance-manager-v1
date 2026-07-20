// lib/presentation/templates/app_split_view.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A split view template with consistent styling.
///
/// This widget provides a standardized split view template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSplitView(
///   left: NavigationList(),
///   right: ContentArea(),
///   splitRatio: 0.25,
///   minLeftWidth: 200,
///   maxLeftWidth: 300,
/// )
/// ```
class AppSplitView extends StatelessWidget {
  /// The left (or top) widget.
  final Widget left;

  /// The right (or bottom) widget.
  final Widget right;

  /// The split ratio (left width / total width).
  final double splitRatio;

  /// The minimum left width.
  final double minLeftWidth;

  /// The maximum left width.
  final double maxLeftWidth;

  /// Whether the split is horizontal or vertical.
  final Axis direction;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppSplitView].
  const AppSplitView({
    super.key,
    required this.left,
    required this.right,
    this.splitRatio = 0.3,
    this.minLeftWidth = 200,
    this.maxLeftWidth = 400,
    this.direction = Axis.horizontal,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = PageStyleBuilder.build(
      context: context,
      variant: variant,
      density: density,
    );

    final body = LayoutBuilder(
      builder: (context, constraints) {
        if (direction == Axis.horizontal) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth * splitRatio.clamp(
                  minLeftWidth / constraints.maxWidth,
                  maxLeftWidth / constraints.maxWidth,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: left,
              ),
              Expanded(
                child: right,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                flex: (splitRatio * 100).toInt(),
                child: left,
              ),
              Container(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                flex: ((1 - splitRatio) * 100).toInt(),
                child: right,
              ),
            ],
          );
        }
      },
    );

    final actions = <Widget>[];
    if (trailing != null) {
      actions.add(trailing!);
    }

    return AppPage(
      child: body,
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions.isNotEmpty ? actions : null,
      variant: variant,
      density: density,
      scrollBehavior: PageScrollBehavior.none,
      appBar: appBar,
    );
  }
}
