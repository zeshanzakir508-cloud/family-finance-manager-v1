// lib/presentation/widgets/data_display/internal/info_pair.dart

import 'package:flutter/material.dart';

/// Internal widget for rendering a key-value pair.
class InfoPair extends StatelessWidget {
  final String key;
  final String value;
  final bool isLast;
  final TextStyle? keyStyle;
  final TextStyle? valueStyle;

  const InfoPair({
    super.key,
    required this.key,
    required this.value,
    this.isLast = false,
    this.keyStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: keyStyle ?? theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle ?? theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
