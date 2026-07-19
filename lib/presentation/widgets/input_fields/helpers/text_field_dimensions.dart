import 'package:flutter/material.dart';

import '../enums/text_field_size.dart';

/// Size helper for AppTextField widgets.
abstract final class TextFieldDimensions {
  /// Returns the minimum height for the given text field size.
  static double minHeight(TextFieldSize size) {
    switch (size) {
      case TextFieldSize.small:
        return 40;

      case TextFieldSize.medium:
        return 48;

      case TextFieldSize.large:
        return 56;
    }
  }

  /// Returns the default icon size for the given text field size.
  static double iconSize(TextFieldSize size) {
    switch (size) {
      case TextFieldSize.small:
        return 18;

      case TextFieldSize.medium:
        return 20;

      case TextFieldSize.large:
        return 22;
    }
  }
}
