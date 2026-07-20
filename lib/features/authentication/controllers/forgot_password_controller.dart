import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../models/password_reset_model.dart';
import 'auth_controller.dart';
import '../validators/email_validator.dart';

/// Forgot password controller state.
class ForgotPasswordState {
  final String email;
  final bool isLoading;
  final bool emailSent;
  final String? error;
  final bool isValid;

  const ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.emailSent = false,
    this.error,
    this.isValid = false,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    bool? emailSent,
    String? error,
    bool? isValid,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      emailSent: emailSent ?? this.emailSent,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// Forgot password controller notifier.
class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final AuthController _authController;

  ForgotPasswordController(this._authController) : super(const ForgotPasswordState());

  /// Updates email field.
  void updateEmail(String email) {
    final trimmed = email.trim();
    final isValid = EmailValidator.isValid(trimmed);
    state = state.copyWith(
      email: trimmed,
      isValid: isValid,
      error: null,
    );
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Sends password reset email.
  Future<Either<AuthResult, void>> sendResetEmail() async {
    if (!state.isValid) {
      return const Left(AuthResult.invalidCredentials);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = PasswordResetModel.forResetLink(
        email: state.email,
      );

      final result = await _authController.sendPasswordResetEmail(request);

      return result.fold(
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(error),
          );
          return Left(error);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            emailSent: true,
            error: null,
          );
          return Right(success);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      return const Left(AuthResult.unknown);
    }
  }

  /// Resets the form state.
  void reset() {
    state = const ForgotPasswordState();
  }

  /// Resets email sent state (for returning to form).
  void resetEmailSent() {
    state = state.copyWith(emailSent: false);
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.userNotFound:
        return 'No account found with this email address.';
      case AuthResult.invalidCredentials:
        return 'Please enter a valid email address.';
      case AuthResult.networkError:
        return 'Network error. Please check your connection.';
      case AuthResult.tooManyRequests:
        return 'Too many attempts. Please try again later.';
      default:
        return 'Failed to send reset email. Please try again.';
    }
  }
}

/// Provider for ForgotPasswordController.
final forgotPasswordControllerProvider = StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>((ref) {
  final authController = ref.watch(authControllerProvider);
  return ForgotPasswordController(authController);
});
