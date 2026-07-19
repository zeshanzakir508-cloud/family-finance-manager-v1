// lib/presentation/widgets/feedback/app_success_state.dart

import 'package:flutter/material.dart';

import '../buttons/app_button.dart';
import 'enums/feedback_type.dart';
import 'helpers/feedback_style_builder.dart';
import 'internal/feedback_icon.dart';
import 'internal/feedback_message.dart';

/// A success state widget with consistent styling.
///
/// This widget provides a standardized success state that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSuccessState(
///   title: 'Payment Successful!',
///   message: 'Your transaction has been completed.',
///   actionLabel: 'Done',
///   onAction: () => Navigator.pop(context),
/// )
/// ```
class AppSuccessState extends StatelessWidget {
  /// The title text.
  final String title;

  /// The optional message text.
  final String? message;

  /// The action button label.
  final String? actionLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onAction;

  /// Whether the button is loading.
  final bool isLoading;

  /// Creates a new [AppSuccessState].
  const AppSuccessState({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = FeedbackStyleBuilder.build(
      context: context,
      type: FeedbackType.success,
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
