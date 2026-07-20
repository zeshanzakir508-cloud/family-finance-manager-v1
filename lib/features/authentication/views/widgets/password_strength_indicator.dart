import 'package:flutter/material.dart';

import '../../enums/password_strength.dart';
import '../../helpers/password_strength_helper.dart';

/// Password strength indicator widget.
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final strength = PasswordStrengthHelper.calculateStrength(password);
    final progress = strength.progress;
    final color = _getStrengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: color,
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              strength.displayName,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (!PasswordStrengthHelper.isAcceptable(strength))
          Text(
            'Password is too weak',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        if (PasswordStrengthHelper.isStrong(strength))
          Text(
            'Strong password!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return Colors.red;
      case PasswordStrength.weak:
        return Colors.orange;
      case PasswordStrength.medium:
        return Colors.yellow.shade700;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.veryStrong:
        return Colors.green.shade700;
    }
  }
}
