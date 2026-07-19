// lib/presentation/widgets/input_fields/app_percentage_field.dart

import 'package:flutter/material.dart';

import 'app_number_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A specialized percentage field for entering percentage values.
///
/// This widget provides a clean API for entering percentage values with
/// a percentage symbol suffix. It allows decimal values and handles
/// both positive and negative percentages.
///
/// Example:
/// ```dart
/// AppPercentageField(
///   controller: _percentageController,
///   labelText: 'Interest Rate',
///   hintText: 'Enter percentage',
///   allowNegative: false,
///   onChanged: (value) => updateRate(value),
/// )
/// ```
class AppPercentageField extends StatelessWidget {
  /// Controller for the percentage field.
  final TextEditingController? controller;

  /// Focus node for the percentage field.
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

  /// The visual variant of the percentage field.
  final TextFieldVariant variant;

  /// The size of the percentage field.
  final TextFieldSize size;

  /// The current state of the percentage field.
  final TextFieldState state;

  /// Whether to allow negative numbers.
  final bool allowNegative;

  /// Custom prefix icon override.
  final Widget? prefixIcon;

  /// Custom suffix icon override.
  final Widget? suffixIcon;

  /// Creates a new [AppPercentageField].
  const AppPercentageField({
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
    this.variant = TextFieldVariant.outlined,
    this.size = TextFieldSize.medium,
    this.state = TextFieldState.normal,
    this.allowNegative = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppNumberField(
      controller: controller,
      focusNode: focusNode,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      autofocus: autofocus,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      textInputAction: textInputAction,
      variant: variant,
      size: size,
      state: state,
      allowDecimal: true,
      allowNegative: allowNegative,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon ?? _buildPercentageSuffix(),
    );
  }

  Widget _buildPercentageSuffix() {
    return const Padding(
      padding: EdgeInsets.only(right: 12, left: 4),
      child: Center(
        child: Text(
          '%',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
