import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/login_controller.dart';
import '../../providers/auth_state_provider.dart';
import '../../helpers/auth_redirect_helper.dart';
import '../../constants/auth_routes.dart';
import '../sections/login_form_section.dart';
import '../sections/social_login_section.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_footer.dart';

/// Login page for user authentication.
class LoginPage extends ConsumerStatefulWidget {
  final String? redirect;

  const LoginPage({super.key, this.redirect});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

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
                title: 'Welcome Back',
                subtitle: 'Login to your account to continue',
              ),

              const SizedBox(height: 32),

              // Login Form
              LoginFormSection(
                state: state,
                onEmailChanged: controller.updateEmail,
                onPasswordChanged: controller.updatePassword,
                onTogglePasswordVisibility: controller.togglePasswordVisibility,
                onToggleRememberMe: controller.toggleRememberMe,
              ),

              const SizedBox(height: 16),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.go(AuthRoutes.forgotPassword);
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () async {
                    final result = await controller.login();
                    result.fold(
                      (error) {
                        // Error handled in controller
                      },
                      (response) {
                        if (mounted) {
                          AuthRedirectHelper.handleLoginSuccess(
                            context,
                            redirectPath: widget.redirect,
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
                      : const Text('Login'),
                ),
              ),

              const SizedBox(height: 24),

              // Or divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              // Social Login
              const SocialLoginSection(),

              const SizedBox(height: 24),

              // Register Link
              AuthFooter(
                text: "Don't have an account?",
                actionText: 'Register',
                onActionPressed: () {
                  context.go(AuthRoutes.register);
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
