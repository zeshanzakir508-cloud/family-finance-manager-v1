// lib/presentation/widgets/feedback/app_empty_state.dart

import 'package:flutter/material.dart';

import '../buttons/app_button.dart';
import 'enums/feedback_type.dart';
import 'helpers/feedback_style_builder.dart';
import 'internal/feedback_icon.dart';
import 'internal/feedback_message.dart';

/// An empty state widget with consistent styling.
///
/// This widget provides a standardized empty state that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppEmptyState(
///   title: 'No transactions yet',
///   message: 'Start tracking your expenses today.',
///   actionLabel: 'Add Transaction',
///   onAction: () => showAddDialog(),
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  /// The title text.
  final String title;

  /// The optional message text.
  final String? message;

  /// The action button label.
  final String? actionLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onAction;

  /// The type of feedback icon.
  final FeedbackType type;

  /// Whether the button is loading.
  final bool isLoading;

  /// Creates a new [AppEmptyState].
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.type = FeedbackType.info,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = FeedbackStyleBuilder.build(
      context: context,
      type: type,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FeedbackIcon(style: style, size: 64),
            const SizedBox(height: 16),
            FeedbackMessage(
              title: title,
              message: message,
              style: style,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                isLoading: isLoading,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
