import 'package:flutter/material.dart';

import '../../controllers/register_controller.dart';
import '../widgets/password_strength_indicator.dart';

/// Register form section widget.
class RegisterFormSection extends StatelessWidget {
  final RegisterState state;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;
  final Function(String) onDisplayNameChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  const RegisterFormSection({
    super.key,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onDisplayNameChanged,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Display Name Field
        TextFormField(
          initialValue: state.displayName,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: onDisplayNameChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Display name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Email Field
        TextFormField(
          initialValue: state.email,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email address',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: onEmailChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Password Field
        TextFormField(
          initialValue: state.password,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.next,
          onChanged: onPasswordChanged,
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

        // Password Strength Indicator
        if (state.password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: PasswordStrengthIndicator(
              password: state.password,
            ),
          ),

        const SizedBox(height: 16),

        // Confirm Password Field
        TextFormField(
          initialValue: state.confirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onToggleConfirmPasswordVisibility,
            ),
          ),
          obscureText: state.obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          onChanged: onConfirmPasswordChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != state.password) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),

        if (state.confirmPassword.isNotEmpty && !state.passwordsMatch)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Passwords do not match',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
