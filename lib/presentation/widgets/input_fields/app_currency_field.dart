// lib/presentation/widgets/input_fields/app_currency_field.dart

import 'package:flutter/material.dart';

import 'app_number_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A currency field with configurable currency symbol and decimal places.
///
/// This widget provides a standardized currency input field that reuses
/// [AppNumberField] with decimal and negative support configured based on
/// the provided parameters.
///
/// Example:
/// ```dart
/// AppCurrencyField(
///   controller: _amountController,
///   labelText: 'Amount',
///   hintText: '0.00',
///   currencySymbol: '\$',
///   decimalPlaces: 2,
///   onChanged: (value) => updateTotal(value),
/// )
/// ```
class AppCurrencyField extends StatelessWidget {
  /// Controller for the currency field.
  final TextEditingController? controller;

  /// Focus node for the currency field.
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

  /// The visual variant of the currency field.
  final TextFieldVariant variant;

  /// The size of the currency field.
  final TextFieldSize size;

  /// The current state of the currency field.
  final TextFieldState state;

  /// The currency symbol to display as prefix.
  final String currencySymbol;

  /// The number of decimal places allowed.
  final int decimalPlaces;

  /// Whether to allow negative numbers.
  final bool allowNegative;

  /// Custom prefix icon override.
  final Widget? prefixIcon;

  /// Creates a new [AppCurrencyField].
  const AppCurrencyField({
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
    this.currencySymbol = '₨',
    this.decimalPlaces = 2,
    this.allowNegative = false,
    this.prefixIcon,
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
      allowDecimal: decimalPlaces > 0,
      allowNegative: allowNegative,
      prefixIcon: prefixIcon ?? _buildCurrencyPrefix(),
    );
  }

  Widget _buildCurrencyPrefix() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 4),
      child: Text(
        currencySymbol,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
