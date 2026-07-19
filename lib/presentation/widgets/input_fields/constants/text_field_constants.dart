import 'package:flutter/material.dart';

/// Default values used by AppTextField widgets.
abstract final class TextFieldConstants {
  /// Border radius.
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(12),
  );

  /// Default horizontal content padding.
  static const double horizontalPadding = 16;

  /// Default vertical content padding.
  static const double verticalPadding = 14;

  /// Border width.
  static const double borderWidth = 1.2;

  /// Focused border width.
  static const double focusedBorderWidth = 2.0;

  /// Prefix/Suffix icon size.
  static const double iconSize = 20;

  /// Default animation duration.
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// Default maximum lines.
  static const int maxLines = 1;

  /// Default minimum lines.
  static const int minLines = 1;
}
