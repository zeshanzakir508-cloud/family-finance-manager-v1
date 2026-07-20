// lib/presentation/templates/app_page.dart

import 'package:flutter/material.dart';

import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';
import 'helpers/page_style_builder.dart';
import 'internal/page_scaffold.dart';
import 'internal/page_header.dart';
import 'internal/page_footer.dart';
import 'internal/page_actions.dart';
import 'internal/page_body.dart';

/// A base page template with consistent styling.
///
/// This widget provides a standardized page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppPage(
///   title: 'Dashboard',
///   subtitle: 'Your financial overview',
///   child: DashboardContent(),
/// )
/// ```
class AppPage extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The footer widget.
  final Widget? footer;

  /// The actions to display.
  final List<Widget>? actions;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The scroll behavior of the page.
  final PageScrollBehavior scrollBehavior;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// The floating action button.
  final Widget? floatingActionButton;

  /// The floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Custom padding override.
  final EdgeInsets? padding;

  /// Creates a new [AppPage].
  const AppPage({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.actions,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.scrollBehavior = PageScrollBehavior.normal,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final style = PageStyleBuilder.build(
      context: context,
      variant: variant,
      density: density,
    );

    final headerChildren = <Widget>[];

    // Header
    if (title != null || subtitle != null || leading != null || trailing != null) {
      headerChildren.add(
        PageHeader(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          spacing: style.spacing,
        ),
      );
    }

    // Actions
    if (actions != null && actions!.isNotEmpty) {
      headerChildren.add(
        PageActions(
          actions: actions!,
          spacing: style.spacing * 0.5,
        ),
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...headerChildren,
        PageBody(
          child: child,
          scrollBehavior: scrollBehavior,
          padding: padding,
        ),
        if (footer != null)
          PageFooter(
            child: footer!,
            spacing: style.spacing,
          ),
      ],
    );

    return PageScaffold(
      body: body,
      style: style,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      padding: padding,
    );
  }
}
