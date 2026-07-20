import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../enums/password_strength.dart';
import '../models/register_request_model.dart';
import '../models/login_response_model.dart';
import 'auth_controller.dart';
import '../validators/email_validator.dart';
import '../validators/password_validator.dart';
import '../validators/username_validator.dart';
import '../helpers/password_strength_helper.dart';

/// Register controller state.
class RegisterState {
  final String email;
  final String password;
  final String confirmPassword;
  final String displayName;
  final String username;
  final String phone;
  final bool isLoading;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final bool acceptPrivacy;
  final String? error;
  final PasswordStrength passwordStrength;
  final bool isValid;

  const RegisterState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.displayName = '',
    this.username = '',
    this.phone = '',
    this.isLoading = false,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptTerms = false,
    this.acceptPrivacy = false,
    this.error,
    this.passwordStrength = PasswordStrength.veryWeak,
    this.isValid = false,
  });

  RegisterState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? displayName,
    String? username,
    String? phone,
    bool? isLoading,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptTerms,
    bool? acceptPrivacy,
    String? error,
    PasswordStrength? passwordStrength,
    bool? isValid,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      acceptPrivacy: acceptPrivacy ?? this.acceptPrivacy,
      error: error ?? this.error,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      isValid: isValid ?? this.isValid,
    );
  }

  bool get passwordsMatch => password == confirmPassword && password.isNotEmpty;
  bool get hasConsent => acceptTerms && acceptPrivacy;
}

/// Register controller notifier.
class RegisterController extends StateNotifier<RegisterState> {
  final AuthController _authController;

  RegisterController(this._authController) : super(const RegisterState());

  /// Updates email field.
  void updateEmail(String email) {
    final trimmed = email.trim();
    final isValid = _validateFields(
      email: trimmed,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: state.username,
    );
    state = state.copyWith(
      email: trimmed,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates password field.
  void updatePassword(String password) {
    final strength = PasswordStrengthHelper.calculateStrength(password);
    final isValid = _validateFields(
      email: state.email,
      password: password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: state.username,
    );
    state = state.copyWith(
      password: password,
      passwordStrength: strength,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates confirm password field.
  void updateConfirmPassword(String confirmPassword) {
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: confirmPassword,
      displayName: state.displayName,
      username: state.username,
    );
    state = state.copyWith(
      confirmPassword: confirmPassword,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates display name field.
  void updateDisplayName(String displayName) {
    final trimmed = displayName.trim();
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: trimmed,
      username: state.username,
    );
    state = state.copyWith(
      displayName: trimmed,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates username field.
  void updateUsername(String username) {
    final trimmed = username.trim();
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: trimmed,
    );
    state = state.copyWith(
      username: trimmed,
      isValid: isValid,
      error: null,
    );
  }

  /// Updates phone field.
  void updatePhone(String phone) {
    final trimmed = phone.trim();
    state = state.copyWith(phone: trimmed, error: null);
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Toggles confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  /// Toggles terms acceptance.
  void toggleTerms() {
    final newValue = !state.acceptTerms;
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: state.username,
      acceptTerms: newValue,
      acceptPrivacy: state.acceptPrivacy,
    );
    state = state.copyWith(
      acceptTerms: newValue,
      isValid: isValid,
      error: null,
    );
  }

  /// Toggles privacy acceptance.
  void togglePrivacy() {
    final newValue = !state.acceptPrivacy;
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: state.username,
      acceptTerms: state.acceptTerms,
      acceptPrivacy: newValue,
    );
    state = state.copyWith(
      acceptPrivacy: newValue,
      isValid: isValid,
      error: null,
    );
  }

  /// Accepts all terms and conditions.
  void acceptAllTerms() {
    state = state.copyWith(
      acceptTerms: true,
      acceptPrivacy: true,
    );
    final isValid = _validateFields(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      displayName: state.displayName,
      username: state.username,
      acceptTerms: true,
      acceptPrivacy: true,
    );
    state = state.copyWith(isValid: isValid);
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Performs registration.
  Future<Either<AuthResult, LoginResponseModel>> register() async {
    if (!state.isValid) {
      return const Left(AuthResult.registerFailed);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterRequestModel(
        email: state.email,
        password: state.password,
        displayName: state.displayName.isNotEmpty ? state.displayName : null,
        username: state.username.isNotEmpty ? state.username : null,
        phone: state.phone.isNotEmpty ? state.phone : null,
        acceptTerms: state.acceptTerms,
        acceptPrivacy: state.acceptPrivacy,
      );

      final result = await _authController.register(request);

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

  /// Resets the registration form.
  void reset() {
    state = const RegisterState();
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  bool _validateFields({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
    required String username,
    bool acceptTerms = false,
    bool acceptPrivacy = false,
  }) {
    final emailValid = EmailValidator.isValid(email);
    final passwordValid = PasswordValidator.isValid(password);
    final passwordsMatch = password == confirmPassword && password.isNotEmpty;
    final displayNameValid = displayName.isEmpty || displayName.length >= 2;
    final usernameValid = username.isEmpty || UsernameValidator.isValid(username);
    final hasConsent = acceptTerms && acceptPrivacy;

    return emailValid &&
        passwordValid &&
        passwordsMatch &&
        displayNameValid &&
        usernameValid &&
        hasConsent;
  }

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.emailAlreadyInUse:
        return 'This email is already registered.';
      case AuthResult.invalidCredentials:
        return 'Please enter valid credentials.';
      case AuthResult.networkError:
        return 'Network error. Please check your connection.';
      case AuthResult.tooManyRequests:
        return 'Too many attempts. Please try again later.';
      default:
        return 'Registration failed. Please try again.';
    }
  }
}

/// Provider for RegisterController.
final registerControllerProvider = StateNotifierProvider<RegisterController, RegisterState>((ref) {
  final authController = ref.watch(authControllerProvider);
  return RegisterController(authController);
});
