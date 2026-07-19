// lib/presentation/widgets/input_fields/app_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';
import 'constants/text_field_constants.dart';
import 'builders/text_field_decoration_builder.dart';
import 'helpers/text_field_dimensions.dart';
import 'helpers/text_field_text_style.dart';

/// A customizable text field with consistent styling.
///
/// This widget provides a standardized text input field that follows the
/// application's design system with support for multiple variants, sizes,
/// and states.
///
/// Example:
/// ```dart
/// AppTextField(
///   controller: _controller,
///   labelText: 'Email',
///   hintText: 'Enter your email',
///   variant: TextFieldVariant.outlined,
///   size: TextFieldSize.medium,
///   onChanged: (value) => validateEmail(value),
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController? controller;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// The label text displayed above the input field.
  final String? labelText;

  /// The hint text displayed inside the input field.
  final String? hintText;

  /// The helper text displayed below the input field.
  final String? helperText;

  /// The error text displayed below the input field.
  final String? errorText;

  /// The widget to display before the input field.
  final Widget? prefixIcon;

  /// The widget to display after the input field.
  final Widget? suffixIcon;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// The minimum number of lines to display.
  final int? minLines;

  /// The maximum number of characters allowed.
  final int? maxLength;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// Callback when the user submits the field.
  final void Function(String)? onFieldSubmitted;

  /// Validator function for the field.
  final String? Function(String?)? validator;

  /// Callback when the field is saved.
  final void Function(String?)? onSaved;

  /// The visual variant of the text field.
  final TextFieldVariant variant;

  /// The size of the text field.
  final TextFieldSize size;

  /// The current state of the text field.
  final TextFieldState state;

  /// Custom input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Custom counter builder for the text field.
  final InputCounterWidgetBuilder? buildCounter;

  /// Creates a new [AppTextField].
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = TextFieldConstants.maxLines,
    this.minLines = TextFieldConstants.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.variant = TextFieldVariant.outlined,
    this.size = TextFieldSize.medium,
    this.state = TextFieldState.normal,
    this.inputFormatters,
    this.buildCounter,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = TextFieldDecorationBuilder.build(
      context: context,
      variant: variant,
      size: size,
      state: state,
      enabled: enabled,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );

    final textStyle = TextFieldTextStyle.of(context, size);

    final textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      style: textStyle,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      buildCounter: buildCounter ?? _defaultBuildCounter,
    );

    // Only apply minHeight constraint for single-line fields
    if (maxLines == 1) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: TextFieldDimensions.minHeight(size),
        ),
        child: textField,
      );
    }

    return textField;
  }

  Widget? _defaultBuildCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    if (maxLength == null) return null;
    return Text(
      '$currentLength / $maxLength',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
