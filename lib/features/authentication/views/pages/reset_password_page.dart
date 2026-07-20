import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../models/password_reset_model.dart';
import '../../constants/auth_routes.dart';
import '../../constants/auth_constants.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_strength_indicator.dart';
import '../../helpers/password_strength_helper.dart';

/// Reset password page for setting new password.
class ResetPasswordPage extends ConsumerStatefulWidget {
  final String email;
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final strength = PasswordStrengthHelper.calculateStrength(password);
    final passwordsMatch = password == _confirmPasswordController.text && password.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Auth Header
                const AuthHeader(
                  title: 'Reset Password',
                  subtitle: 'Create a new password for your account',
                ),

                const SizedBox(height: 32),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < AuthConstants.minPasswordLength) {
                      return 'Password must be at least ${AuthConstants.minPasswordLength} characters';
                    }
                    if (!PasswordStrengthHelper.meetsAllRequirements(value)) {
                      return 'Password does not meet all requirements';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 8),

                // Password Strength Indicator
                PasswordStrengthIndicator(password: password),

                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your new password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 8),

                if (_confirmPasswordController.text.isNotEmpty && !passwordsMatch)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Passwords do not match',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),

                // Reset Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });

                        try {
                          final authController = ref.read(authControllerProvider);
                          final request = PasswordResetModel(
                            email: widget.email,
                            token: widget.token,
                            newPassword: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                          );

                          final result = await authController.resetPassword(request);

                          result.fold(
                            (error) {
                              setState(() {
                                _isLoading = false;
                                _error = 'Password reset failed. Please try again.';
                              });
                            },
                            (success) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password reset successful! Please login.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context.go(AuthRoutes.login);
                              }
                            },
                          );
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                            _error = 'An unexpected error occurred. Please try again.';
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                        : const Text('Reset Password'),
                  ),
                ),

                const SizedBox(height: 16),

                // Back to Login
                TextButton(
                  onPressed: () {
                    context.go(AuthRoutes.login);
                  },
                  child: const Text('Back to Login'),
                ),

                const SizedBox(height: 20),

                // Error message
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
