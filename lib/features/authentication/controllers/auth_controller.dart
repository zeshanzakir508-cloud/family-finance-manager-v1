import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../enums/auth_status.dart';
import '../models/auth_session_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/password_reset_model.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verification_model.dart';
import '../models/email_verification_model.dart';
import '../repositories/auth_repository.dart';
import '../services/session_service.dart';
import '../services/remember_me_service.dart';
import '../services/biometric_service.dart';
import '../../../models/user_model.dart';

/// Main authentication controller.
class AuthController {
  final AuthRepository _authRepository;
  final SessionService _sessionService;
  final RememberMeService _rememberMeService;
  final BiometricService _biometricService;

  AuthController({
    required AuthRepository authRepository,
    required SessionService sessionService,
    required RememberMeService rememberMeService,
    required BiometricService biometricService,
  }) : _authRepository = authRepository,
       _sessionService = sessionService,
       _rememberMeService = rememberMeService,
       _biometricService = biometricService;

  /// Login with email and password.
  Future<Either<AuthResult, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    return await _authRepository.login(request);
  }

  /// Register a new user.
  Future<Either<AuthResult, LoginResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    return await _authRepository.register(request);
  }

  /// Logout the current user.
  Future<Either<AuthResult, void>> logout() async {
    return await _authRepository.logout();
  }

  /// Get current authenticated user.
  Future<Either<AuthResult, UserModel>> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  /// Get user by ID.
  Future<UserModel?> getUserById(String userId) async {
    return await _authRepository.getUserById(userId);
  }

  /// Validate the current session.
  Future<bool> validateSession(AuthSessionModel session) async {
    return await _authRepository.validateSession(session);
  }

  /// Refresh authentication token.
  Future<Either<AuthResult, AuthSessionModel>> refreshToken(
    String refreshToken,
  ) async {
    return await _authRepository.refreshToken(refreshToken);
  }

  /// Send password reset email.
  Future<Either<AuthResult, void>> sendPasswordResetEmail(
    PasswordResetModel request,
  ) async {
    return await _authRepository.sendPasswordResetEmail(request);
  }

  /// Reset password with token.
  Future<Either<AuthResult, void>> resetPassword(
    PasswordResetModel request,
  ) async {
    return await _authRepository.resetPassword(request);
  }

  /// Send email verification.
  Future<Either<AuthResult, void>> sendEmailVerification(
    EmailVerificationModel request,
  ) async {
    return await _authRepository.sendEmailVerification(request);
  }

  /// Verify email with token.
  Future<Either<AuthResult, void>> verifyEmail(
    EmailVerificationModel request,
  ) async {
    return await _authRepository.verifyEmail(request);
  }

  /// Request OTP.
  Future<Either<AuthResult, void>> requestOtp(
    OtpRequestModel request,
  ) async {
    return await _authRepository.requestOtp(request);
  }

  /// Verify OTP.
  Future<Either<AuthResult, void>> verifyOtp(
    OtpVerificationModel request,
  ) async {
    return await _authRepository.verifyOtp(request);
  }

  /// Delete user account.
  Future<Either<AuthResult, void>> deleteAccount() async {
    return await _authRepository.deleteAccount();
  }

  /// Auto-login with stored credentials.
  Future<Either<AuthResult, LoginResponseModel>> autoLogin() async {
    return await _authRepository.autoLogin();
  }

  /// Check if user is blocked.
  Future<bool> isUserBlocked(String userId) async {
    return await _authRepository.isUserBlocked(userId);
  }

  /// Update user profile.
  Future<Either<AuthResult, UserModel>> updateProfile(UserModel user) async {
    return await _authRepository.updateProfile(user);
  }

  /// Change user password.
  Future<Either<AuthResult, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Check if email exists.
  Future<bool> emailExists(String email) async {
    return await _authRepository.emailExists(email);
  }

  //--------------------------------------------------------------------------
  // Session Management
  //--------------------------------------------------------------------------

  /// Save session.
  Future<void> saveSession(AuthSessionModel session) async {
    await _sessionService.saveSession(session);
  }

  /// Restore session.
  Future<AuthSessionModel?> restoreSession() async {
    return await _sessionService.restoreSession();
  }

  /// Clear session.
  Future<void> clearSession() async {
    await _sessionService.clearSession();
  }

  /// Check if session exists.
  Future<bool> hasSession() async {
    return await _sessionService.hasSession();
  }

  /// Check if session is expired.
  Future<bool> isSessionExpired() async {
    return await _sessionService.isSessionExpired();
  }

  /// Check if session is expiring soon.
  Future<bool> isSessionExpiringSoon() async {
    return await _sessionService.isSessionExpiringSoon();
  }

  //--------------------------------------------------------------------------
  // Remember Me
  //--------------------------------------------------------------------------

  /// Save credentials for remember me.
  Future<void> saveRememberMeCredentials({
    required String email,
    required String password,
    String? userId,
    String? deviceId,
  }) async {
    await _rememberMeService.saveCredentials(
      email: email,
      password: password,
      userId: userId,
      deviceId: deviceId,
    );
  }

  /// Get stored credentials.
  Future<RememberMeModel?> getRememberMeCredentials() async {
    return await _rememberMeService.getCredentials();
  }

  /// Clear stored credentials.
  Future<void> clearRememberMeCredentials() async {
    await _rememberMeService.clearCredentials();
  }

  /// Check if remember me is enabled.
  Future<bool> isRememberMeEnabled() async {
    return await _rememberMeService.isEnabled();
  }

  //--------------------------------------------------------------------------
  // Biometric
  //--------------------------------------------------------------------------

  /// Check if biometric is available.
  Future<bool> isBiometricAvailable() async {
    return await _biometricService.isBiometricAvailable();
  }

  /// Check if biometric is enabled.
  Future<bool> isBiometricEnabled() async {
    return await _biometricService.isBiometricEnabled();
  }

  /// Enable biometric.
  Future<void> enableBiometric() async {
    await _biometricService.enableBiometric();
  }

  /// Disable biometric.
  Future<void> disableBiometric() async {
    await _biometricService.disableBiometric();
  }

  /// Authenticate with biometric.
  Future<bool> authenticateWithBiometric({required String reason}) async {
    return await _biometricService.authenticate(reason: reason);
  }
}
