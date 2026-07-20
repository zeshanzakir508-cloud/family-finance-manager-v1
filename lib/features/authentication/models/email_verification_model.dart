import 'package:equatable/equatable.dart';

/// Email verification model.
///
/// Represents the data required for email verification operations.
class EmailVerificationModel extends Equatable {
  /// User email address
  final String email;

  /// Verification token
  final String? token;

  /// Verification code (OTP)
  final String? code;

  /// Whether to resend verification email
  final bool resend;

  const EmailVerificationModel({
    required this.email,
    this.token,
    this.code,
    this.resend = false,
  });

  /// Creates a copy with updated fields.
  EmailVerificationModel copyWith({
    String? email,
    String? token,
    String? code,
    bool? resend,
  }) {
    return EmailVerificationModel(
      email: email ?? this.email,
      token: token ?? this.token,
      code: code ?? this.code,
      resend: resend ?? this.resend,
    );
  }

  /// Creates a model for sending verification email.
  factory EmailVerificationModel.forSend({
    required String email,
  }) {
    return EmailVerificationModel(
      email: email,
    );
  }

  /// Creates a model for resending verification email.
  factory EmailVerificationModel.forResend({
    required String email,
  }) {
    return EmailVerificationModel(
      email: email,
      resend: true,
    );
  }

  /// Creates a model for verifying with token.
  factory EmailVerificationModel.forVerifyWithToken({
    required String email,
    required String token,
  }) {
    return EmailVerificationModel(
      email: email,
      token: token,
    );
  }

  /// Creates a model for verifying with OTP.
  factory EmailVerificationModel.forVerifyWithCode({
    required String email,
    required String code,
  }) {
    return EmailVerificationModel(
      email: email,
      code: code,
    );
  }

  /// Returns true if this is a verification request.
  bool get isVerification => token != null || code != null;

  /// Returns true if this is a token-based verification.
  bool get isTokenVerification => token != null && token!.isNotEmpty;

  /// Returns true if this is a code-based verification.
  bool get isCodeVerification => code != null && code!.isNotEmpty;

  /// Returns true if this is a resend request.
  bool get isResend => resend;

  @override
  List<Object?> get props => [
        email,
        token,
        code,
        resend,
      ];
}
