import 'package:flutter/material.dart';

import '../constants/text_field_constants.dart';
import '../enums/text_field_size.dart';

/// Returns content padding for different text field sizes.
abstract final class TextFieldPadding {
  /// Returns the content padding based on the selected size.
  static EdgeInsetsGeometry of(TextFieldSize size) {
    switch (size) {
      case TextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: TextFieldConstants.horizontalPadding,
          vertical: 10,
        );

      case TextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: TextFieldConstants.horizontalPadding,
          vertical: TextFieldConstants.verticalPadding,
        );

      case TextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: TextFieldConstants.horizontalPadding,
          vertical: 18,
        );
    }
  }
}
