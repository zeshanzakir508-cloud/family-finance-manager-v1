// lib/presentation/templates/app_form_page.dart

import 'package:flutter/material.dart';

import '../../widgets/buttons/app_button.dart';
import '../../widgets/buttons/enums/app_button_variant.dart';
import '../../widgets/buttons/enums/app_button_size.dart';
import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A form page template with consistent styling.
///
/// This widget provides a standardized form page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppFormPage(
///   title: 'Add Transaction',
///   child: TransactionForm(),
///   onSave: () => saveTransaction(),
///   onCancel: () => Navigator.pop(context),
///   isSaving: isSaving,
/// )
/// ```
class AppFormPage extends StatelessWidget {
  /// The form child widget.
  final Widget child;

  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// Callback when save is pressed.
  final VoidCallback? onSave;

  /// Callback when cancel is pressed.
  final VoidCallback? onCancel;

  /// Whether the form is saving.
  final bool isSaving;

  /// The save button label.
  final String saveLabel;

  /// The cancel button label.
  final String cancelLabel;

  /// Whether to show the cancel button.
  final bool showCancel;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppFormPage].
  const AppFormPage({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onSave,
    this.onCancel,
    this.isSaving = false,
    this.saveLabel = 'Save',
    this.cancelLabel = 'Cancel',
    this.showCancel = true,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final footer = Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (showCancel && onCancel != null)
            Expanded(
              child: AppButton(
                label: cancelLabel,
                onPressed: onCancel,
                variant: AppButtonVariant.text,
                size: AppButtonSize.medium,
              ),
            ),
          if (showCancel && onCancel != null)
            const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppButton(
              label: saveLabel,
              onPressed: onSave,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.medium,
              isLoading: isSaving,
            ),
          ),
        ],
      ),
    );

    final actions = <Widget>[];
    if (trailing != null) {
      actions.add(trailing!);
    }

    return AppPage(
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      footer: footer,
      actions: actions.isNotEmpty ? actions : null,
      variant: variant,
      density: density,
      scrollBehavior: PageScrollBehavior.normal,
      appBar: appBar,
    );
  }
}
