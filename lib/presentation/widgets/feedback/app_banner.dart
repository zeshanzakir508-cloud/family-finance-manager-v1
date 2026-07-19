// lib/presentation/widgets/feedback/app_banner.dart

import 'package:flutter/material.dart';

import 'enums/feedback_type.dart';
import 'helpers/feedback_style_builder.dart';
import 'internal/feedback_icon.dart';
import 'internal/feedback_message.dart';

/// A banner with consistent styling.
///
/// This widget provides a standardized banner that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppBanner(
///   type: FeedbackType.warning,
///   title: 'Low Balance',
///   message: 'Your account balance is low. Please add funds.',
/// )
/// ```
class AppBanner extends StatelessWidget {
  /// The type of feedback to display.
  final FeedbackType type;

  /// The title text.
  final String title;

  /// The optional message text.
  final String? message;

  /// Whether the banner can be dismissed.
  final bool dismissible;

  /// Callback when the banner is dismissed.
  final VoidCallback? onDismiss;

  /// Creates a new [AppBanner].
  const AppBanner({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.dismissible = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final style = FeedbackStyleBuilder.build(
      context: context,
      type: type,
    );

    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
      ),
      child: Row(
        children: [
          FeedbackIcon(style: style, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: FeedbackMessage(
              title: title,
              message: message,
              style: style,
              textAlign: TextAlign.start,
            ),
          ),
          if (dismissible)
            IconButton(
              icon: Icon(
                Icons.close,
                color: style.foregroundColor,
                size: 20,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
