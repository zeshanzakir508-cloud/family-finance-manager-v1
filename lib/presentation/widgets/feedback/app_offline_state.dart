// lib/presentation/widgets/feedback/app_offline_state.dart

import 'package:flutter/material.dart';

import '../buttons/app_button.dart';
import 'enums/feedback_type.dart';
import 'helpers/feedback_style_builder.dart';
import 'internal/feedback_icon.dart';
import 'internal/feedback_message.dart';

/// An offline state widget with consistent styling.
///
/// This widget provides a standardized offline state that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppOfflineState(
///   title: 'No Internet Connection',
///   message: 'Please check your connection and try again.',
///   onRetry: () => checkConnection(),
/// )
/// ```
class AppOfflineState extends StatelessWidget {
  /// The title text.
  final String title;

  /// The optional message text.
  final String? message;

  /// Callback when the retry button is pressed.
  final VoidCallback? onRetry;

  /// The retry button label.
  final String retryLabel;

  /// Whether the button is loading.
  final bool isLoading;

  /// Creates a new [AppOfflineState].
  const AppOfflineState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = FeedbackStyleBuilder.build(
      context: context,
      type: FeedbackType.warning,
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
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: retryLabel,
                onPressed: onRetry,
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
