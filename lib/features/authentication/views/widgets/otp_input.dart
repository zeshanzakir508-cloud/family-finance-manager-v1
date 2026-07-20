import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// OTP input widget for verification codes.
class OtpInput extends StatelessWidget {
  final int length;
  final Function(String) onChanged;
  final Function(String) onCompleted;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Center(
      child: Pinput(
        length: length,
        onChanged: onChanged,
        onCompleted: onCompleted,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration?.copyWith(
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration?.copyWith(
            border: Border.all(color: Colors.red),
          ),
        ),
        showCursor: true,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
