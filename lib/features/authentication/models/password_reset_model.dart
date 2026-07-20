import 'package:equatable/equatable.dart';

/// Password reset model.
///
/// Represents the data required for password reset operations.
class PasswordResetModel extends Equatable {
  /// User email address
  final String email;

  /// Reset token
  final String? token;

  /// New password
  final String? newPassword;

  /// Confirm new password
  final String? confirmPassword;

  /// Reset code (OTP)
  final String? resetCode;

  const PasswordResetModel({
    required this.email,
    this.token,
    this.newPassword,
    this.confirmPassword,
    this.resetCode,
  });

  /// Creates a copy with updated fields.
  PasswordResetModel copyWith({
    String? email,
    String? token,
    String? newPassword,
    String? confirmPassword,
    String? resetCode,
  }) {
    return PasswordResetModel(
      email: email ?? this.email,
      token: token ?? this.token,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resetCode: resetCode ?? this.resetCode,
    );
  }

  /// Creates a request model for sending reset link.
  factory PasswordResetModel.forResetLink({required String email}) {
    return PasswordResetModel(email: email);
  }

  /// Creates a request model for resetting password with token.
  factory PasswordResetModel.forReset({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return PasswordResetModel(
      email: email,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  /// Creates a request model for resetting password with OTP.
  factory PasswordResetModel.forOtpReset({
    required String email,
    required String resetCode,
    required String newPassword,
    required String confirmPassword,
  }) {
    return PasswordResetModel(
      email: email,
      resetCode: resetCode,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  /// Returns true if passwords match.
  bool get passwordsMatch => newPassword == confirmPassword;

  /// Returns true if this is a complete reset request.
  bool get isComplete => token != null || resetCode != null;

  /// Returns true if this is a token-based reset.
  bool get isTokenReset => token != null && token!.isNotEmpty;

  /// Returns true if this is an OTP-based reset.
  bool get isOtpReset => resetCode != null && resetCode!.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        token,
        newPassword,
        confirmPassword,
        resetCode,
      ];
}
