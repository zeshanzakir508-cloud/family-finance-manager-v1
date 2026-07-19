// lib/presentation/widgets/app_bars/helpers/search_bar_style_builder.dart

import 'package:flutter/material.dart';

/// Builder class for creating consistent search bar styles.
///
/// This class constructs [SearchBarStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for search bar styling.
///
/// Example:
/// ```dart
/// final style = SearchBarStyleBuilder.build(
///   context: context,
///   enabled: true,
/// );
///
/// final colors = style.resolve(
///   enabled: true,
/// );
/// ```
abstract final class SearchBarStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [SearchBarStyle] configuration with the given parameters.
  static SearchBarStyle build({
    required BuildContext context,
    required bool enabled,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final backgroundColor = colorScheme.surface;
    final foregroundColor = colorScheme.onSurface;
    final disabledBackgroundColor = colorScheme.surface.withOpacity(
      _disabledOpacity,
    );
    final disabledForegroundColor = colorScheme.onSurface.withOpacity(
      _disabledOpacity,
    );
    final borderColor = colorScheme.outlineVariant;
    final disabledBorderColor = colorScheme.outlineVariant.withOpacity(
      _disabledOpacity,
    );
    final borderRadius = BorderRadius.circular(12);
    final elevation = 0;
    final iconSize = 20.0;
    final textStyle = textTheme.bodyMedium?.copyWith(
      color: foregroundColor,
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
    final hintStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
    final contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    );

    return SearchBarStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      disabledBorderColor: disabledBorderColor,
      borderRadius: borderRadius,
      elevation: elevation,
      iconSize: iconSize,
      textStyle: textStyle,
      hintStyle: hintStyle,
      contentPadding: contentPadding,
    );
  }
}

/// Style configuration for search bars.
///
/// Contains all visual properties needed to style a search bar consistently.
@immutable
class SearchBarStyle {
  /// The background color of the search bar.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the search bar.
  final Color foregroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The border color of the search bar.
  final Color borderColor;

  /// The border color when disabled.
  final Color disabledBorderColor;

  /// The border radius of the search bar.
  final BorderRadius borderRadius;

  /// The elevation (shadow depth) of the search bar.
  final double elevation;

  /// The size of icons in the search bar.
  final double iconSize;

  /// The text style of the input text.
  final TextStyle textStyle;

  /// The text style of the hint text.
  final TextStyle hintStyle;

  /// The content padding inside the search bar.
  final EdgeInsets contentPadding;

  /// Creates a new [SearchBarStyle].
  const SearchBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.borderColor,
    required this.disabledBorderColor,
    required this.borderRadius,
    required this.elevation,
    required this.iconSize,
    required this.textStyle,
    required this.hintStyle,
    required this.contentPadding,
  });

  /// Resolves the appropriate colors based on the search bar's state.
  ///
  /// Parameters:
  ///   - [enabled]: Whether the search bar is enabled.
  ///
  /// Returns:
  ///   A [SearchBarColors] object containing the resolved background,
  ///   foreground, and border colors.
  SearchBarColors resolve({
    required bool enabled,
  }) {
    if (!enabled) {
      return SearchBarColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
        border: disabledBorderColor,
      );
    }

    return SearchBarColors(
      background: backgroundColor,
      foreground: foregroundColor,
      border: borderColor,
    );
  }
}

/// Resolved colors for a search bar based on its state.
@immutable
class SearchBarColors {
  /// The background color of the search bar.
  final Color background;

  /// The foreground color (text/icon) of the search bar.
  final Color foreground;

  /// The border color of the search bar.
  final Color border;

  /// Creates a new [SearchBarColors].
  const SearchBarColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}
