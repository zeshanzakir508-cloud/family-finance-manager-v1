// lib/presentation/widgets/data_display/app_status_indicator.dart

import 'package:flutter/material.dart';

/// A status indicator widget with consistent styling.
///
/// This widget provides a standardized status indicator that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppStatusIndicator(
///   status: 'Active',
///   color: Colors.green,
/// )
/// ```
class AppStatusIndicator extends StatelessWidget {
  /// The status text.
  final String status;

  /// The color of the indicator.
  final Color color;

  /// Whether to show a dot indicator.
  final bool showDot;

  /// Creates a new [AppStatusIndicator].
  const AppStatusIndicator({
    super.key,
    required this.status,
    required this.color,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          status,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
