import 'package:firebase_auth/firebase_auth.dart';

/// Abstract service for authentication operations.
///
/// Defines the contract for Firebase Authentication operations.
abstract class AuthService {
  /// Get current authenticated user.
  User? get currentUser;

  /// Login with email and password.
  Future<UserCredential?> login({
    required String? email,
    required String? password,
  });

  /// Register with email and password.
  Future<UserCredential?> register({
    required String email,
    required String password,
  });

  /// Logout current user.
  Future<void> logout();

  /// Send email verification.
  Future<void> sendEmailVerification();

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email);

  /// Confirm password reset.
  Future<void> confirmPasswordReset(String code, String newPassword);

  /// Apply action code (email verification).
  Future<void> applyActionCode(String code);

  /// Validate token.
  Future<bool> validateToken(String token);

  /// Refresh authentication token.
  Future<String?> refreshToken(String refreshToken);

  /// Delete user account.
  Future<void> deleteAccount();

  /// Change user password.
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Send OTP email.
  Future<void> sendOtpEmail(String email);

  /// Send phone OTP.
  Future<void> sendPhoneOtp(String phoneNumber);

  /// Verify OTP.
  Future<bool> verifyOtp(String otp, String verificationId);

  /// Fetch sign-in methods for email.
  Future<List<String>> fetchSignInMethodsForEmail(String email);

  /// Re-authenticate user.
  Future<void> reauthenticate(String password);
}
