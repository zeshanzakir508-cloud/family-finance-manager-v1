// lib/presentation/templates/app_detail_page.dart

import 'package:flutter/material.dart';

import '../../widgets/buttons/app_button.dart';
import '../../widgets/buttons/enums/app_button_variant.dart';
import '../../widgets/buttons/enums/app_button_size.dart';
import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A detail page template with consistent styling.
///
/// This widget provides a standardized detail page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppDetailPage(
///   title: 'Transaction Details',
///   child: TransactionDetail(),
///   actions: [
///     IconButton(icon: Icons.edit, onPressed: () {}),
///   ],
///   onDelete: () => deleteTransaction(),
/// )
/// ```
class AppDetailPage extends StatelessWidget {
  /// The detail child widget.
  final Widget child;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The actions to display.
  final List<Widget>? actions;

  /// Callback when delete is pressed.
  final VoidCallback? onDelete;

  /// Whether the delete button is destructive.
  final bool isDestructive;

  /// The delete button label.
  final String deleteLabel;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppDetailPage].
  const AppDetailPage({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.onDelete,
    this.isDestructive = true,
    this.deleteLabel = 'Delete',
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final allActions = <Widget>[];

    if (actions != null) {
      allActions.addAll(actions!);
    }

    if (onDelete != null) {
      allActions.add(
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    return AppPage(
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      actions: allActions.isNotEmpty ? allActions : null,
      variant: variant,
      density: density,
      scrollBehavior: PageScrollBehavior.normal,
      appBar: appBar,
    );
  }
}
