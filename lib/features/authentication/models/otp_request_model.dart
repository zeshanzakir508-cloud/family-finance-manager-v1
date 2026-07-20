import 'package:equatable/equatable.dart';

import '../enums/otp_type.dart';

/// OTP request model.
///
/// Represents the data required to request an OTP.
class OtpRequestModel extends Equatable {
  /// Email address
  final String? email;

  /// Phone number
  final String? phone;

  /// OTP type
  final OtpType type;

  /// User ID (for authenticated users)
  final String? userId;

  const OtpRequestModel({
    this.email,
    this.phone,
    required this.type,
    this.userId,
  });

  /// Creates a copy with updated fields.
  OtpRequestModel copyWith({
    String? email,
    String? phone,
    OtpType? type,
    String? userId,
  }) {
    return OtpRequestModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }

  /// Creates an OTP request for email verification.
  factory OtpRequestModel.forEmailVerification({
    required String email,
    String? userId,
  }) {
    return OtpRequestModel(
      email: email,
      type: OtpType.emailVerification,
      userId: userId,
    );
  }

  /// Creates an OTP request for phone verification.
  factory OtpRequestModel.forPhoneVerification({
    required String phone,
    String? userId,
  }) {
    return OtpRequestModel(
      phone: phone,
      type: OtpType.phoneVerification,
      userId: userId,
    );
  }

  /// Creates an OTP request for password reset.
  factory OtpRequestModel.forPasswordReset({
    required String email,
  }) {
    return OtpRequestModel(
      email: email,
      type: OtpType.passwordReset,
    );
  }

  /// Creates an OTP request for two-factor authentication.
  factory OtpRequestModel.forTwoFactorAuth({
    required String userId,
    required String email,
  }) {
    return OtpRequestModel(
      email: email,
      type: OtpType.twoFactorAuth,
      userId: userId,
    );
  }

  /// Creates an OTP request for login verification.
  factory OtpRequestModel.forLoginVerification({
    required String email,
  }) {
    return OtpRequestModel(
      email: email,
      type: OtpType.loginVerification,
    );
  }

  /// Returns true if the request has an email.
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Returns true if the request has a phone number.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        phone,
        type,
        userId,
      ];
}
