// lib/presentation/templates/app_dashboard_page.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A dashboard page template with consistent styling.
///
/// This widget provides a standardized dashboard page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppDashboardPage(
///   title: 'Dashboard',
///   subtitle: 'Your financial overview',
///   header: SummaryCards(),
///   widgets: [Chart(), TransactionsList()],
///   gridColumns: 2,
/// )
/// ```
class AppDashboardPage extends StatelessWidget {
  /// The header widget.
  final Widget? header;

  /// The list of dashboard widgets.
  final List<Widget> widgets;

  /// The number of grid columns.
  final int gridColumns;

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

  /// Creates a new [AppDashboardPage].
  const AppDashboardPage({
    super.key,
    this.header,
    required this.widgets,
    this.gridColumns = 2,
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
    final style = PageStyleBuilder.build(
      context: context,
      variant: variant,
      density: density,
    );

    final children = <Widget>[];

    if (header != null) {
      children.add(header!);
      children.add(SizedBox(height: style.spacing));
    }

    if (widgets.isNotEmpty) {
      children.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns,
            crossAxisSpacing: style.spacing * 0.5,
            mainAxisSpacing: style.spacing * 0.5,
            childAspectRatio: 1.5,
          ),
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
        ),
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
      scrollBehavior: PageScrollBehavior.normal,
      appBar: appBar,
    );
  }
}
