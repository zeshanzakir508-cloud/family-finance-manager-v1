import 'package:flutter/material.dart';

/// Remember me tile widget.
class RememberMeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const Text('Remember Me'),
        const Spacer(),
        TextButton(
          onPressed: () {
            // Navigate to forgot password
          },
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }
}
