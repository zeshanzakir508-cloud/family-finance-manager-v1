import 'package:flutter/material.dart';

import '../constants/text_field_constants.dart';
import '../enums/text_field_state.dart';

/// Builds borders for AppTextField.
abstract final class TextFieldBorder {
  /// Returns an [OutlineInputBorder] using the supplied color and width.
  static OutlineInputBorder outline({
    required Color color,
    double width = TextFieldConstants.borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: TextFieldConstants.borderRadius,
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  /// Returns the appropriate color based on the field state.
  static Color stateColor({
    required BuildContext context,
    required TextFieldState state,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case TextFieldState.normal:
        return colorScheme.outline;

      case TextFieldState.success:
        return Colors.green;

      case TextFieldState.error:
        return colorScheme.error;

      case TextFieldState.warning:
        return Colors.orange;
    }
  }
}
