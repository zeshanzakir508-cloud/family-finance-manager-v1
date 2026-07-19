import 'package:flutter/material.dart';

import '../enums/text_field_size.dart';

/// Typography helper for AppTextField widgets.
abstract final class TextFieldTextStyle {
  /// Returns the text style for the selected text field size.
  static TextStyle of(
    BuildContext context,
    TextFieldSize size,
  ) {
    final textTheme = Theme.of(context).textTheme;

    switch (size) {
      case TextFieldSize.small:
        return textTheme.bodySmall!;

      case TextFieldSize.medium:
        return textTheme.bodyMedium!;

      case TextFieldSize.large:
        return textTheme.bodyLarge!;
    }
  }
}
