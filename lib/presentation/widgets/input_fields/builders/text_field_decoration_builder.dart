import 'package:flutter/material.dart';

import '../constants/text_field_constants.dart';
import '../enums/text_field_state.dart';
import '../enums/text_field_variant.dart';
import '../helpers/text_field_border.dart';
import '../helpers/text_field_padding.dart';
import '../helpers/text_field_text_style.dart';
import '../enums/text_field_size.dart';

/// Builds the decoration for AppTextField.
abstract final class TextFieldDecorationBuilder {
  /// Returns the [InputDecoration] for an AppTextField.
  static InputDecoration build({
    required BuildContext context,
    required TextFieldVariant variant,
    required TextFieldSize size,
    required TextFieldState state,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    final color = TextFieldBorder.stateColor(
      context: context,
      state: state,
    );

    final border = TextFieldBorder.outline(color: color);

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      isDense: true,
      contentPadding: TextFieldPadding.of(size),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: variant == TextFieldVariant.filled,
      border: variant == TextFieldVariant.underlined
          ? const UnderlineInputBorder()
          : border,
      enabledBorder: variant == TextFieldVariant.underlined
          ? const UnderlineInputBorder()
          : border,
      focusedBorder: variant == TextFieldVariant.underlined
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: color,
                width: TextFieldConstants.focusedBorderWidth,
              ),
            )
          : TextFieldBorder.outline(
              color: color,
              width: TextFieldConstants.focusedBorderWidth,
            ),
      disabledBorder: variant == TextFieldVariant.underlined
          ? const UnderlineInputBorder()
          : border,
      errorBorder: TextFieldBorder.outline(
        color: Theme.of(context).colorScheme.error,
      ),
      focusedErrorBorder: TextFieldBorder.outline(
        color: Theme.of(context).colorScheme.error,
        width: TextFieldConstants.focusedBorderWidth,
      ),
      hintStyle: TextFieldTextStyle.of(context, size),
    );
  }
}
