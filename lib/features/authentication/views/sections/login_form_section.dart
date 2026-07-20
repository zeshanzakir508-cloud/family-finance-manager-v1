import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/login_controller.dart';
import '../widgets/remember_me_tile.dart';

/// Login form section widget.
class LoginFormSection extends StatelessWidget {
  final LoginState state;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleRememberMe;

  const LoginFormSection({
    super.key,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePasswordVisibility,
    required this.onToggleRememberMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          textInputAction: TextInputAction.done,
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

        const SizedBox(height: 16),

        // Remember Me
        RememberMeTile(
          value: state.rememberMe,
          onChanged: (_) => onToggleRememberMe(),
        ),
      ],
    );
  }
}
