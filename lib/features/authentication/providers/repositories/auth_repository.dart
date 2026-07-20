import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../models/auth_session_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/password_reset_model.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verification_model.dart';
import '../models/email_verification_model.dart';
import '../../../models/user_model.dart';

/// Abstract repository interface for authentication operations.
///
/// Defines the contract for all authentication-related data operations.
abstract class AuthRepository {
  /// Login with credentials.
  Future<Either<AuthResult, LoginResponseModel>> login(
    LoginRequestModel request,
  );

  /// Register a new user.
  Future<Either<AuthResult, LoginResponseModel>> register(
    RegisterRequestModel request,
  );

  /// Logout the current user.
  Future<Either<AuthResult, void>> logout();

  /// Get current user profile.
  Future<Either<AuthResult, UserModel>> getCurrentUser();

  /// Get user by ID.
  Future<UserModel?> getUserById(String userId);

  /// Validate session token.
  Future<bool> validateSession(AuthSessionModel session);

  /// Refresh authentication tokens.
  Future<Either<AuthResult, AuthSessionModel>> refreshToken(
    String refreshToken,
  );

  /// Send password reset email.
  Future<Either<AuthResult, void>> sendPasswordResetEmail(
    PasswordResetModel request,
  );

  /// Reset password with token.
  Future<Either<AuthResult, void>> resetPassword(
    PasswordResetModel request,
  );

  /// Send email verification.
  Future<Either<AuthResult, void>> sendEmailVerification(
    EmailVerificationModel request,
  );

  /// Verify email with token.
  Future<Either<AuthResult, void>> verifyEmail(
    EmailVerificationModel request,
  );

  /// Request OTP.
  Future<Either<AuthResult, void>> requestOtp(
    OtpRequestModel request,
  );

  /// Verify OTP.
  Future<Either<AuthResult, void>> verifyOtp(
    OtpVerificationModel request,
  );

  /// Delete user account.
  Future<Either<AuthResult, void>> deleteAccount();

  /// Auto-login with stored credentials.
  Future<Either<AuthResult, LoginResponseModel>> autoLogin();

  /// Check if user is blocked.
  Future<bool> isUserBlocked(String userId);

  /// Update user profile.
  Future<Either<AuthResult, UserModel>> updateProfile(
    UserModel user,
  );

  /// Change user password.
  Future<Either<AuthResult, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Check if email exists.
  Future<bool> emailExists(String email);
}
