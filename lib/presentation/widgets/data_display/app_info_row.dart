// lib/presentation/widgets/data_display/app_info_row.dart

import 'package:flutter/material.dart';

import 'internal/info_pair.dart';

/// An info row widget for displaying a single key-value pair.
///
/// This widget provides a standardized info row that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppInfoRow(
///   key: 'Status',
///   value: 'Active',
/// )
/// ```
class AppInfoRow extends StatelessWidget {
  /// The key text.
  final String key;

  /// The value text.
  final String value;

  /// Whether the value text should be bold.
  final bool bold;

  /// Creates a new [AppInfoRow].
  const AppInfoRow({
    super.key,
    required this.key,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoPair(
      key: key,
      value: value,
      keyStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      valueStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
