// lib/presentation/templates/app_tab_page.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A tabbed page template with consistent styling.
///
/// This widget provides a standardized tabbed page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppTabPage(
///   title: 'Analytics',
///   tabs: [
///     Tab(text: 'Income'),
///     Tab(text: 'Expenses'),
///     Tab(text: 'Balance'),
///   ],
///   tabViews: [
///     IncomeChart(),
///     ExpensesChart(),
///     BalanceChart(),
///   ],
/// )
/// ```
class AppTabPage extends StatefulWidget {
  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The tabs to display.
  final List<Tab> tabs;

  /// The views for each tab.
  final List<Widget> tabViews;

  /// The initial tab index.
  final int initialIndex;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppTabPage].
  const AppTabPage({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.tabs,
    required this.tabViews,
    this.initialIndex = 0,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  State<AppTabPage> createState() => _AppTabPageState();
}

class _AppTabPageState extends State<AppTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final body = Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          unselectedLabelStyle:
              Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );

    final actions = <Widget>[];
    if (widget.trailing != null) {
      actions.add(widget.trailing!);
    }

    return AppPage(
      child: body,
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      actions: actions.isNotEmpty ? actions : null,
      variant: widget.variant,
      density: widget.density,
      scrollBehavior: PageScrollBehavior.none,
      appBar: widget.appBar,
    );
  }
}
