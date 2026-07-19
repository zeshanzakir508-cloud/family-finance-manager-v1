// lib/presentation/widgets/feedback/app_snackbar.dart

import 'package:flutter/material.dart';

import 'enums/feedback_type.dart';
import 'helpers/feedback_style_builder.dart';
import 'internal/feedback_icon.dart';
import 'internal/feedback_message.dart';

/// A snackbar with consistent styling.
///
/// This widget provides a standardized snackbar that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSnackbar.show(
///   context,
///   type: FeedbackType.success,
///   title: 'Success!',
///   message: 'Your changes have been saved.',
/// );
/// ```
class AppSnackbar {
  /// Shows a snackbar with the given parameters.
  static void show(
    BuildContext context, {
    required FeedbackType type,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final style = FeedbackStyleBuilder.build(
      context: context,
      type: type,
    );

    final messenger = ScaffoldMessenger.of(context);

    final snackBar = SnackBar(
      content: Row(
        children: [
          FeedbackIcon(style: style, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: FeedbackMessage(
              title: title,
              message: message,
              style: style,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      backgroundColor: style.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: style.borderRadius,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      duration: duration,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: style.iconColor,
            )
          : null,
    );

    messenger.showSnackBar(snackBar);
  }
}
