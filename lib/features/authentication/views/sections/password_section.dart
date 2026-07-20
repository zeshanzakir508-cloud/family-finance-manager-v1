import 'package:flutter/material.dart';

import '../../enums/password_strength.dart';
import '../widgets/password_strength_indicator.dart';

/// Password section widget for password input with strength indicator.
class PasswordSection extends StatefulWidget {
  final String password;
  final bool obscurePassword;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleVisibility;
  final String? labelText;
  final String? hintText;

  const PasswordSection({
    super.key,
    required this.password,
    required this.obscurePassword,
    required this.onPasswordChanged,
    required this.onToggleVisibility,
    this.labelText,
    this.hintText,
  });

  @override
  State<PasswordSection> createState() => _PasswordSectionState();
}

class _PasswordSectionState extends State<PasswordSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          obscureText: widget.obscurePassword,
          decoration: InputDecoration(
            labelText: widget.labelText ?? 'Password',
            hintText: widget.hintText ?? 'Enter your password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                widget.obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: widget.onToggleVisibility,
            ),
          ),
          onChanged: widget.onPasswordChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        if (widget.password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: PasswordStrengthIndicator(
              password: widget.password,
            ),
          ),
      ],
    );
  }
}
