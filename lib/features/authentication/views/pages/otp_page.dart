import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/otp_controller.dart';
import '../../enums/otp_type.dart';
import '../../constants/auth_routes.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_input.dart';
import '../widgets/resend_timer.dart';

/// OTP verification page.
class OtpPage extends ConsumerStatefulWidget {
  final String email;
  final String otpType;

  const OtpPage({
    super.key,
    required this.email,
    required this.otpType,
  });

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  @override
  void initState() {
    super.initState();
    _initializeOtp();
  }

  void _initializeOtp() {
    final controller = ref.read(otpControllerProvider.notifier);
    final type = _parseOtpType(widget.otpType);
    controller.initializeWithEmail(
      email: widget.email,
      type: type,
    );
  }

  OtpType _parseOtpType(String type) {
    switch (type) {
      case 'emailVerification':
        return OtpType.emailVerification;
      case 'phoneVerification':
        return OtpType.phoneVerification;
      case 'passwordReset':
        return OtpType.passwordReset;
      case 'twoFactorAuth':
        return OtpType.twoFactorAuth;
      case 'loginVerification':
        return OtpType.loginVerification;
      default:
        return OtpType.emailVerification;
    }
  }

  String _getTitle() {
    final type = _parseOtpType(widget.otpType);
    switch (type) {
      case OtpType.emailVerification:
        return 'Verify Email';
      case OtpType.phoneVerification:
        return 'Verify Phone';
      case OtpType.passwordReset:
        return 'Reset Password';
      case OtpType.twoFactorAuth:
        return 'Two-Factor Authentication';
      case OtpType.loginVerification:
        return 'Login Verification';
    }
  }

  String _getSubtitle() {
    final type = _parseOtpType(widget.otpType);
    switch (type) {
      case OtpType.emailVerification:
        return 'Enter the 6-digit code sent to your email';
      case OtpType.phoneVerification:
        return 'Enter the 6-digit code sent to your phone';
      case OtpType.passwordReset:
        return 'Enter the verification code sent to your email';
      case OtpType.twoFactorAuth:
        return 'Enter the 6-digit code from your authenticator app';
      case OtpType.loginVerification:
        return 'Enter the verification code sent to your email';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerProvider);
    final controller = ref.read(otpControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Auth Header
              AuthHeader(
                title: _getTitle(),
                subtitle: _getSubtitle(),
              ),

              const SizedBox(height: 32),

              // OTP Input
              OtpInput(
                length: 6,
                onChanged: (value) {
                  controller.updateOtp(value);
                },
                onCompleted: (value) {
                  // Auto-verify when complete
                  _verifyOtp(controller);
                },
              ),

              const SizedBox(height: 24),

              // Error message
              if (state.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading || !state.isValid
                      ? null
                      : () => _verifyOtp(controller),
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text('Verify'),
                ),
              ),

              const SizedBox(height: 16),

              // Resend Timer
              ResendTimer(
                canResend: state.canResend,
                remainingSeconds: state.remainingSeconds,
                onResend: () async {
                  final result = await controller.resendOtp();
                  result.fold(
                    (error) {
                      // Error handled in controller
                    },
                    (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OTP resent successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Back button
              TextButton(
                onPressed: () {
                  context.go(AuthRoutes.login);
                },
                child: const Text('Back to Login'),
              ),

              // Success state
              if (state.isVerified)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Verification successful!',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(OtpController controller) async {
    final result = await controller.verifyOtp();
    result.fold(
      (error) {
        // Error handled in controller
      },
      (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.go('/dashboard');
            }
          });
        }
      },
    );
  }
}
