// lib/presentation/widgets/input_fields/app_password_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_text_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A password field with built-in visibility toggle.
///
/// This widget provides a standardized password input field with a lock icon,
/// visibility toggle button, and secure text entry by default.
///
/// Example:
/// ```dart
/// AppPasswordField(
///   controller: _passwordController,
///   labelText: 'Password',
///   hintText: 'Enter your password',
///   onChanged: (value) => validatePassword(value),
/// )
/// ```
class AppPasswordField extends StatefulWidget {
  /// Controller for the password field.
  final TextEditingController? controller;

  /// Focus node for the password field.
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

  /// Custom input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// The visual variant of the password field.
  final TextFieldVariant variant;

  /// The size of the password field.
  final TextFieldSize size;

  /// The current state of the password field.
  final TextFieldState state;

  /// Custom prefix icon override.
  final Widget? prefixIcon;

  /// Creates a new [AppPasswordField].
  const AppPasswordField({
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
    this.prefixIcon,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      labelText: widget.labelText,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      maxLines: 1,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      variant: widget.variant,
      size: widget.size,
      state: widget.state,
      prefixIcon: widget.prefixIcon ?? const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: _toggleVisibility,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        splashRadius: 16,
      ),
    );
  }

  void _toggleVisibility() {
    final controller = widget.controller;
    final selection = controller?.selection;

    setState(() {
      _obscureText = !_obscureText;
    });

    // Preserve cursor position after toggling visibility
    if (controller != null && selection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.selection = selection;
      });
    }
  }
}
