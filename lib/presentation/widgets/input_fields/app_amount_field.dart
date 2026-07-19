// lib/presentation/widgets/input_fields/app_amount_field.dart

import 'package:flutter/material.dart';

import 'app_currency_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A specialized amount field for monetary input throughout the app.
///
/// This widget provides a finance-oriented wrapper around [AppCurrencyField]
/// with a clean API for entering monetary amounts. It presets decimal places
/// to 2 and uses the application's default currency symbol.
///
/// Example:
/// ```dart
/// AppAmountField(
///   controller: _amountController,
///   labelText: 'Amount',
///   hintText: 'Enter amount',
///   onChanged: (value) => updateTotal(value),
/// )
/// ```
class AppAmountField extends StatelessWidget {
  /// Controller for the amount field.
  final TextEditingController? controller;

  /// Focus node for the amount field.
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

  /// The visual variant of the amount field.
  final TextFieldVariant variant;

  /// The size of the amount field.
  final TextFieldSize size;

  /// The current state of the amount field.
  final TextFieldState state;

  /// Whether to allow negative numbers.
  final bool allowNegative;

  /// The currency symbol to display.
  final String currencySymbol;

  /// Custom prefix icon override.
  final Widget? prefixIcon;

  /// Creates a new [AppAmountField].
  const AppAmountField({
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
    this.currencySymbol = '₨',
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCurrencyField(
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
      decimalPlaces: 2,
      allowNegative: allowNegative,
      currencySymbol: currencySymbol,
      prefixIcon: prefixIcon,
    );
  }
}
