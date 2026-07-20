import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../models/email_verification_model.dart';
import '../../constants/auth_routes.dart';
import '../../constants/auth_constants.dart';
import '../widgets/auth_header.dart';

/// Verify email page for email verification.
class VerifyEmailPage extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailPage({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool _isLoading = false;
  bool _isVerified = false;
  bool _isResending = false;
  String? _error;
  int _resendCount = 0;
  int _remainingSeconds = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          }
          if (_remainingSeconds == 0) {
            _canResend = true;
          }
        });
      }
      return _remainingSeconds > 0 && mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Header
              const AuthHeader(
                title: 'Verify Your Email',
                subtitle: 'We\'ve sent a verification link to your email',
              ),

              const SizedBox(height: 32),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isVerified ? Colors.green[100] : Colors.blue[100],
                ),
                child: Icon(
                  _isVerified ? Icons.check_circle : Icons.email,
                  size: 40,
                  color: _isVerified ? Colors.green : Colors.blue,
                ),
              ),

              const SizedBox(height: 24),

              // Email display
              Text(
                widget.email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Status message
              Text(
                _isVerified
                    ? 'Your email has been verified successfully!'
                    : 'Please check your email and click the verification link',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              if (!_isVerified) ...[
                Text(
                  'If you don\'t see the email, check your spam folder',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32),

              // Action buttons
              if (!_isVerified) ...[
                // Resend button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_canResend && !_isResending)
                        ? () async {
                            setState(() {
                              _isResending = true;
                              _error = null;
                            });

                            try {
                              final authController = ref.read(authControllerProvider);
                              final request = EmailVerificationModel.forResend(
                                email: widget.email,
                              );

                              final result = await authController.sendEmailVerification(request);

                              result.fold(
                                (error) {
                                  setState(() {
                                    _isResending = false;
                                    _error = 'Failed to resend verification email';
                                  });
                                },
                                (success) {
                                  setState(() {
                                    _isResending = false;
                                    _resendCount++;
                                    _startTimer();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Verification email resent!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              );
                            } catch (e) {
                              setState(() {
                                _isResending = false;
                                _error = 'An unexpected error occurred';
                              });
                            }
                          }
                        : null,
                    child: _isResending
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                        : Text(_canResend
                            ? 'Resend Verification Email'
                            : 'Resend in ${_remainingSeconds}s'),
                  ),
                ),

                const SizedBox(height: 16),

                // Check verification status
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });

                    // Simulate checking verification
                    await Future.delayed(const Duration(seconds: 2));

                    // In a real app, you would check with Firebase
                    // For demo purposes, we'll just show a message
                    setState(() {
                      _isLoading = false;
                      _error = 'Please verify your email using the link sent to your inbox';
                    });
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('I have verified my email'),
                ),
              ],

              const SizedBox(height: 16),

              // Continue button (after verification)
              if (_isVerified)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/dashboard');
                    },
                    child: const Text('Continue to Dashboard'),
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
    );
  }
}
