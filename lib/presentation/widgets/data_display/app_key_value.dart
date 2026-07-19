// lib/presentation/widgets/data_display/app_key_value.dart

import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import '../cards/enums/card_variant.dart';
import '../cards/enums/card_elevation.dart';
import 'internal/info_pair.dart';

/// A key-value display widget.
///
/// This widget provides a standardized key-value display that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppKeyValue(
///   pairs: [
///     KeyValuePair(key: 'Account', value: 'Cash'),
///     KeyValuePair(key: 'Amount', value: 'PKR 2,500'),
///     KeyValuePair(key: 'Date', value: 'Today'),
///   ],
/// )
/// ```
class AppKeyValue extends StatelessWidget {
  /// The list of key-value pairs.
  final List<KeyValuePair> pairs;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a new [AppKeyValue].
  const AppKeyValue({
    super.key,
    required this.pairs,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      backgroundColor: backgroundColor,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: pairs.asMap().entries.map((entry) {
          final index = entry.key;
          final pair = entry.value;
          final isLast = index == pairs.length - 1;
          return InfoPair(
            key: pair.key,
            value: pair.value,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }
}

/// A key-value pair.
class KeyValuePair {
  /// The key text.
  final String key;

  /// The value text.
  final String value;

  /// Creates a new [KeyValuePair].
  const KeyValuePair({
    required this.key,
    required this.value,
  });
}
