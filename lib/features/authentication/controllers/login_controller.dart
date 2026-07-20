import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../enums/login_method.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import 'auth_controller.dart';
import '../validators/email_validator.dart';
import '../validators/password_validator.dart';

/// Login controller state.
class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final bool obscurePassword;
  final bool rememberMe;
  final String? error;
  final bool isValid;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.obscurePassword = true,
    this.rememberMe = false,
    this.error,
    this.isValid = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscurePassword,
    bool? rememberMe,
    String? error,
    bool? isValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  String toString() =>
      'LoginState(email: $email, isLoading: $isLoading, isValid: $isValid, error: $error)';
}

/// Login controller notifier.
class LoginController extends StateNotifier<LoginState> {
  final AuthController _authController;

  LoginController(this._authController) : super(const LoginState());

  /// Updates email field.
  void updateEmail(String email) {
    final trimmed = email.trim();
    final isValid = _validateFields(trimmed, state.password);
    state = state.copyWith(
      email: trimmed,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates password field.
  void updatePassword(String password) {
    final isValid = _validateFields(state.email, password);
    state = state.copyWith(
      password: password,
      isValid: isValid,
      error: null,
    );
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Toggles remember me.
  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  /// Sets remember me explicitly.
  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Performs login.
  Future<Either<AuthResult, LoginResponseModel>> login() async {
    if (!state.isValid) {
      return const Left(AuthResult.invalidCredentials);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequestModel.emailPassword(
        email: state.email,
        password: state.password,
        rememberMe: state.rememberMe,
      );

      final result = await _authController.login(request);

      return result.fold(
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(error),
          );
          return Left(error);
        },
        (response) {
          state = state.copyWith(
            isLoading: false,
            error: null,
          );
          return Right(response);
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

  /// Performs Google login.
  Future<Either<AuthResult, LoginResponseModel>> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement Google Sign-In
      // This would integrate with Google Sign-In plugin
      final result = await _authController.login(
        LoginRequestModel.google(
          idToken: 'google_id_token', // Get from Google Sign-In
          rememberMe: state.rememberMe,
        ),
      );

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google login failed',
      );
      return const Left(AuthResult.unknown);
    }
  }

  /// Performs biometric login.
  Future<Either<AuthResult, LoginResponseModel>> loginWithBiometric({
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authenticated = await _authController.authenticateWithBiometric(
        reason: 'Authenticate to login',
      );

      if (!authenticated) {
        state = state.copyWith(
          isLoading: false,
          error: 'Biometric authentication failed',
        );
        return const Left(AuthResult.biometricFailed);
      }

      final result = await _authController.login(
        LoginRequestModel.biometric(
          userId: userId,
          rememberMe: state.rememberMe,
        ),
      );

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Biometric login failed',
      );
      return const Left(AuthResult.biometricFailed);
    }
  }

  /// Resets the login form.
  void reset() {
    state = const LoginState();
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  bool _validateFields(String email, String password) {
    final emailValid = EmailValidator.isValid(email);
    final passwordValid = PasswordValidator.isValid(password);
    return emailValid && passwordValid;
  }

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.invalidCredentials:
        return 'Please enter a valid email and password.';
      case AuthResult.userNotFound:
        return 'No account found with this email.';
      case AuthResult.wrongPassword:
        return 'Incorrect password. Please try again.';
      case AuthResult.emailNotVerified:
        return 'Please verify your email before logging in.';
      case AuthResult.accountBlocked:
        return 'Your account has been blocked. Please contact support.';
      case AuthResult.accountDisabled:
        return 'Your account has been disabled. Please contact support.';
      case AuthResult.tooManyRequests:
        return 'Too many attempts. Please try again later.';
      case AuthResult.networkError:
        return 'Network error. Please check your connection.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}

/// Provider for LoginController.
final loginControllerProvider = StateNotifierProvider<LoginController, LoginState>((ref) {
  final authController = ref.watch(authControllerProvider);
  return LoginController(authController);
});
