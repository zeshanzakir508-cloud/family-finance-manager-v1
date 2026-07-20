import 'package:flutter/material.dart';

import '../widgets/otp_input.dart';
import '../widgets/resend_timer.dart';

/// OTP section widget.
class OtpSection extends StatelessWidget {
  final String otpCode;
  final bool isLoading;
  final bool canResend;
  final int remainingSeconds;
  final String? error;
  final bool isVerified;
  final Function(String) onOtpChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  const OtpSection({
    super.key,
    required this.otpCode,
    required this.isLoading,
    required this.canResend,
    required this.remainingSeconds,
    this.error,
    this.isVerified = false,
    required this.onOtpChanged,
    required this.onVerify,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // OTP Input
        OtpInput(
          length: 6,
          onChanged: onOtpChanged,
          onCompleted: (_) {
            if (otpCode.length == 6) {
              onVerify();
            }
          },
        ),

        const SizedBox(height: 24),

        // Error message
        if (error != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

        if (error != null) const SizedBox(height: 16),

        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading || otpCode.length < 6
                ? null
                : onVerify,
            child: isLoading
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
          canResend: canResend,
          remainingSeconds: remainingSeconds,
          onResend: onResend,
        ),

        // Success state
        if (isVerified)
          Container(
            margin: const EdgeInsets.only(top: 16),
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
    );
  }
}
