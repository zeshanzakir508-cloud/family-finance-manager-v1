// lib/presentation/widgets/input_fields/app_number_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_text_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A number field with configurable decimal and negative support.
///
/// This widget provides a standardized numeric input field with configurable
/// options for decimal numbers and negative values. It uses input formatters
/// to restrict input to valid numbers only.
///
/// Example:
/// ```dart
/// AppNumberField(
///   controller: _amountController,
///   labelText: 'Amount',
///   hintText: '0.00',
///   allowDecimal: true,
///   allowNegative: false,
///   onChanged: (value) => updateTotal(value),
/// )
/// ```
class AppNumberField extends StatelessWidget {
  /// Controller for the number field.
  final TextEditingController? controller;

  /// Focus node for the number field.
  final FocusNode? focusNode;

  /// The label text displayed above the input field.
  final String? labelText;

  /// The hint text displayed inside the input field.
  final String? hintText;

  /// The helper text displayed below the input field.
  final String? helperText;

  /// The error text displayed below the input field.
  final String? errorText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Validator function for the field.
  final String? Function(String?)? validator;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits the field.
  final void Function(String)? onFieldSubmitted;

  /// Callback when the field is saved.
  final void Function(String?)? onSaved;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Custom input formatters (overrides default number formatters).
  final List<TextInputFormatter>? inputFormatters;

  /// The visual variant of the number field.
  final TextFieldVariant variant;

  /// The size of the number field.
  final TextFieldSize size;

  /// The current state of the number field.
  final TextFieldState state;

  /// Whether to allow decimal numbers.
  final bool allowDecimal;

  /// Whether to allow negative numbers.
  final bool allowNegative;

  /// Custom prefix icon.
  final Widget? prefixIcon;

  /// Creates a new [AppNumberField].
  const AppNumberField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.variant = TextFieldVariant.outlined,
    this.size = TextFieldSize.medium,
    this.state = TextFieldState.normal,
    this.allowDecimal = false,
    this.allowNegative = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      autofocus: autofocus,
      readOnly: readOnly,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: allowNegative,
      ),
      textInputAction: textInputAction,
      maxLines: 1,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters ?? _buildDefaultFormatters(),
      variant: variant,
      size: size,
      state: state,
      prefixIcon: prefixIcon,
    );
  }

  List<TextInputFormatter> _buildDefaultFormatters() {
    return [
      _NumberTextInputFormatter(
        allowDecimal: allowDecimal,
        allowNegative: allowNegative,
      ),
    ];
  }
}

/// A custom text input formatter for number fields.
///
/// This formatter handles incremental input for numbers with optional
/// decimal and negative support, ensuring valid intermediate states.
class _NumberTextInputFormatter extends TextInputFormatter {
  /// Whether to allow decimal numbers.
  final bool allowDecimal;

  /// Whether to allow negative numbers.
  final bool allowNegative;

  /// Creates a new [_NumberTextInputFormatter].
  const _NumberTextInputFormatter({
    required this.allowDecimal,
    required this.allowNegative,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Check for valid number pattern
    final pattern = StringBuffer(r'^');
    if (allowNegative) {
      pattern.write(r'-?');
    }
    if (allowDecimal) {
      pattern.write(r'\d*(\.\d*)?');
    } else {
      pattern.write(r'\d*');
    }
    pattern.write(r'$');

    final regex = RegExp(pattern.toString());

    // If the new value matches the pattern, accept it
    if (regex.hasMatch(text)) {
      return newValue;
    }

    // If the new value doesn't match, try to find the last valid state
    // by removing the last character(s) until we find a valid state
    for (var i = text.length - 1; i >= 0; i--) {
      final candidate = text.substring(0, i);
      if (regex.hasMatch(candidate) || candidate.isEmpty) {
        return newValue.copyWith(
          text: candidate,
          selection: TextSelection.collapsed(offset: candidate.length),
        );
      }
    }

    // Fallback: reject the change
    return oldValue;
  }
}
