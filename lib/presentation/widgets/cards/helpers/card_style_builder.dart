import 'package:flutter/material.dart';

import '../enums/card_elevation.dart';
import '../enums/card_variant.dart';

/// A lightweight style model for configuring an [AppCard].
@immutable
class CardStyle {
  /// Background color of the card.
  final Color backgroundColor;

  /// Border displayed around the card.
  final BorderSide? border;

  /// Elevation of the card.
  final double elevation;

  /// Shape of the card.
  final ShapeBorder shape;

  /// Creates a new [CardStyle].
  const CardStyle({
    required this.backgroundColor,
    required this.border,
    required this.elevation,
    required this.shape,
  });
}

/// Builds a consistent [CardStyle] based on the current theme,
/// card variant, and elevation.
abstract final class CardStyleBuilder {
  /// Returns the resolved style for an [AppCard].
  static CardStyle build({
    required BuildContext context,
    required CardVariant variant,
    required CardElevation elevation,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final border = switch (variant) {
      CardVariant.outlined =>
        BorderSide(color: colorScheme.outlineVariant),
      _ => null,
    };

    final backgroundColor = switch (variant) {
      CardVariant.filled => colorScheme.surface,
      CardVariant.outlined => colorScheme.surface,
      CardVariant.elevated => colorScheme.surface,
      CardVariant.tonal => colorScheme.secondaryContainer,
    };

    return CardStyle(
      backgroundColor: backgroundColor,
      border: border,
      elevation: _resolveElevation(elevation),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: border ?? BorderSide.none,
      ),
    );
  }

  static double _resolveElevation(CardElevation elevation) {
    switch (elevation) {
      case CardElevation.none:
        return 0;
      case CardElevation.low:
        return 1;
      case CardElevation.medium:
        return 3;
      case CardElevation.high:
        return 6;
    }
  }

  // Prevent instantiation.
  const CardStyleBuilder._();
}
