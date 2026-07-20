import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/register_controller.dart';
import '../../helpers/auth_redirect_helper.dart';
import '../../constants/auth_routes.dart';
import '../sections/register_form_section.dart';
import '../sections/terms_section.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_footer.dart';

/// Register page for new user registration.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final controller = ref.read(registerControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Auth Header
              const AuthHeader(
                title: 'Create Account',
                subtitle: 'Join our family finance community',
              ),

              const SizedBox(height: 32),

              // Register Form
              RegisterFormSection(
                state: state,
                onEmailChanged: controller.updateEmail,
                onPasswordChanged: controller.updatePassword,
                onConfirmPasswordChanged: controller.updateConfirmPassword,
                onDisplayNameChanged: controller.updateDisplayName,
                onTogglePasswordVisibility: controller.togglePasswordVisibility,
                onToggleConfirmPasswordVisibility: controller.toggleConfirmPasswordVisibility,
              ),

              const SizedBox(height: 16),

              // Terms Section
              TermsSection(
                onTermsAccepted: (accepted) {
                  if (accepted) {
                    controller.toggleTerms();
                  }
                },
                onPrivacyAccepted: (accepted) {
                  if (accepted) {
                    controller.togglePrivacy();
                  }
                },
              ),

              const SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () async {
                    final result = await controller.register();
                    result.fold(
                      (error) {
                        // Error handled in controller
                      },
                      (response) {
                        if (mounted) {
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration successful! Please verify your email.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Navigate to verification
                          context.go(
                            '${AuthRoutes.verifyEmail}?email=${state.email}',
                          );
                        }
                      },
                    );
                  },
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 24),

              // Login Link
              AuthFooter(
                text: 'Already have an account?',
                actionText: 'Login',
                onActionPressed: () {
                  context.go(AuthRoutes.login);
                },
              ),

              const SizedBox(height: 20),

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
            ],
          ),
        ),
      ),
    );
  }
}
