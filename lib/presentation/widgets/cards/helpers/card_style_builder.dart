// lib/presentation/widgets/cards/helpers/card_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/card_variant.dart';
import '../enums/card_elevation.dart';

/// Builder class for creating consistent card styles.
///
/// This class constructs [CardStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for card styling.
///
/// Example:
/// ```dart
/// final style = CardStyleBuilder.build(
///   context: context,
///   variant: CardVariant.filled,
///   elevation: CardElevation.low,
/// );
/// ```
abstract final class CardStyleBuilder {
  /// Builds a [CardStyle] configuration with the given parameters.
  static CardStyle build({
    required BuildContext context,
    required CardVariant variant,
    required CardElevation elevation,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    double elevationValue;
    BorderSide? border;

    switch (variant) {
      case CardVariant.filled:
        backgroundColor = colorScheme.surface;
        border = null;
        break;
      case CardVariant.outlined:
        backgroundColor = colorScheme.surface;
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        break;
      case CardVariant.elevated:
        backgroundColor = colorScheme.surface;
        border = null;
        break;
      case CardVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        border = null;
        break;
    }

    switch (elevation) {
      case CardElevation.none:
        elevationValue = 0;
        break;
      case CardElevation.low:
        elevationValue = 1;
        break;
      case CardElevation.medium:
        elevationValue = 2;
        break;
      case CardElevation.high:
        elevationValue = 4;
        break;
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: border ?? BorderSide.none,
    );

    return CardStyle(
      backgroundColor: backgroundColor,
      elevation: elevationValue,
      shape: shape,
      border: border,
    );
  }
}

/// Style configuration for cards.
///
/// Contains all visual properties needed to style a card consistently.
class CardStyle {
  /// The background color of the card.
  final Color backgroundColor;

  /// The elevation (shadow depth) of the card.
  final double elevation;

  /// The shape (including border radius and border) of the card.
  final ShapeBorder shape;

  /// The border of the card, if any.
  final BorderSide? border;

  /// Creates a new [CardStyle].
  const CardStyle({
    required this.backgroundColor,
    required this.elevation,
    required this.shape,
    this.border,
  });
}
