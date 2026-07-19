// lib/presentation/widgets/feedback/helpers/feedback_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/feedback_type.dart';

/// Builder class for creating consistent feedback styles.
///
/// This class constructs [FeedbackStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for feedback styling.
///
/// Example:
/// ```dart
/// final style = FeedbackStyleBuilder.build(
///   context: context,
///   type: FeedbackType.success,
/// );
/// ```
abstract final class FeedbackStyleBuilder {
  /// Builds a [FeedbackStyle] configuration with the given parameters.
  static FeedbackStyle build({
    required BuildContext context,
    required FeedbackType type,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case FeedbackType.success:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        iconColor = colorScheme.primary;
        iconData = Icons.check_circle;
        break;

      case FeedbackType.info:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        iconColor = colorScheme.primary;
        iconData = Icons.info;
        break;

      case FeedbackType.warning:
        backgroundColor = colorScheme.tertiaryContainer;
        foregroundColor = colorScheme.onTertiaryContainer;
        iconColor = colorScheme.tertiary;
        iconData = Icons.warning;
        break;

      case FeedbackType.error:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        iconColor = colorScheme.error;
        iconData = Icons.error;
        break;
    }

    final titleStyle = textTheme.titleMedium?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final messageStyle = textTheme.bodyMedium?.copyWith(
      color: foregroundColor.withOpacity(0.8),
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return FeedbackStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconColor: iconColor,
      iconData: iconData,
      titleStyle: titleStyle,
      messageStyle: messageStyle,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
    );
  }
}

/// Style configuration for feedback states.
@immutable
class FeedbackStyle {
  /// The background color of the feedback.
  final Color backgroundColor;

  /// The foreground color (text) of the feedback.
  final Color foregroundColor;

  /// The color of the icon.
  final Color iconColor;

  /// The icon data to display.
  final IconData iconData;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the message.
  final TextStyle messageStyle;

  /// The border radius of the feedback.
  final BorderRadius borderRadius;

  /// The padding inside the feedback.
  final EdgeInsets padding;

  /// Creates a new [FeedbackStyle].
  const FeedbackStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    required this.iconData,
    required this.titleStyle,
    required this.messageStyle,
    required this.borderRadius,
    required this.padding,
  });
}
