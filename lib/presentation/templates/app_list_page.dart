// lib/presentation/templates/app_list_page.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A list page template with consistent styling.
///
/// This widget provides a standardized list page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppListPage(
///   title: 'Transactions',
///   items: transactions,
///   itemBuilder: (item) => TransactionTile(item: item),
///   onAdd: () => navigateToAddTransaction(),
/// )
/// ```
class AppListPage<T> extends StatelessWidget {
  /// The list of items.
  final List<T> items;

  /// The item builder.
  final Widget Function(T item) itemBuilder;

  /// The separator builder.
  final Widget Function(int index)? separatorBuilder;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// Callback when add button is pressed.
  final VoidCallback? onAdd;

  /// The empty state widget.
  final Widget? emptyState;

  /// The loading state widget.
  final Widget? loadingState;

  /// Whether the list is loading.
  final bool isLoading;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// The floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Creates a new [AppListPage].
  const AppListPage({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onAdd,
    this.emptyState,
    this.loadingState,
    this.isLoading = false,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget child;

    if (isLoading) {
      child = loadingState ??
          const Center(
            child: CircularProgressIndicator(),
          );
    } else if (items.isEmpty) {
      child = emptyState ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
    } else {
      child = ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(items[index]),
        separatorBuilder: separatorBuilder ??
            (index) => Divider(
                  color: colorScheme.outlineVariant,
                  height: 1,
                ),
      );
    }

    final actions = <Widget>[];
    if (trailing != null) {
      actions.add(trailing!);
    }
    if (onAdd != null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
        ),
      );
    }

    return AppPage(
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions.isNotEmpty ? actions : null,
      variant: variant,
      density: density,
      scrollBehavior: PageScrollBehavior.none,
      appBar: appBar,
      floatingActionButton: onAdd != null
          ? FloatingActionButton(
              onPressed: onAdd,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
