import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/google_login_button.dart';

/// Social login section widget.
class SocialLoginSection extends ConsumerWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Google Login Button
        GoogleLoginButton(
          onPressed: () {
            // TODO: Implement Google Sign-In
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google Sign-In coming soon'),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Future: Apple Login Button
        // Future: Facebook Login Button
      ],
    );
  }
}
