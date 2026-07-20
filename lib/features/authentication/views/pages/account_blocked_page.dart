import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/auth_routes.dart';
import '../../providers/auth_state_provider.dart';
import '../../helpers/auth_redirect_helper.dart';
import '../widgets/auth_header.dart';

/// Account blocked page shown when user account is blocked.
class AccountBlockedPage extends ConsumerStatefulWidget {
  const AccountBlockedPage({super.key});

  @override
  ConsumerState<AccountBlockedPage> createState() => _AccountBlockedPageState();
}

class _AccountBlockedPageState extends ConsumerState<AccountBlockedPage> {
  bool _isLoggingOut = false;

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

              // Auth Header
              const AuthHeader(
                title: 'Account Blocked',
                subtitle: 'Your account has been temporarily blocked',
              ),

              const SizedBox(height: 32),

              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[100],
                ),
                child: const Icon(
                  Icons.block,
                  size: 50,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 24),

              // Message
              Text(
                'We\'ve detected unusual activity on your account',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'For your security, your account has been temporarily blocked. '
                'Please contact support to resolve this issue.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Block reason
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Possible reasons:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Multiple failed login attempts'),
                    const Text('• Suspicious activity detected'),
                    const Text('• Terms of service violation'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Support button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement support contact
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Support contact coming soon'),
                      ),
                    );
                  },
                  child: const Text('Contact Support'),
                ),
              ),

              const SizedBox(height: 16),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isLoggingOut
                      ? null
                      : () async {
                          setState(() {
                            _isLoggingOut = true;
                          });

                          // Show confirmation dialog
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            // Logout and redirect to login
                            final authState = ref.read(authStateNotifierProvider.notifier);
                            authState.setUnauthenticated();
                            
                            if (mounted) {
                              context.go(AuthRoutes.login);
                            }
                          }

                          setState(() {
                            _isLoggingOut = false;
                          });
                        },
                  child: _isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Logout'),
                ),
              ),

              const SizedBox(height: 16),

              // Back to login
              TextButton(
                onPressed: () {
                  context.go(AuthRoutes.login);
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
