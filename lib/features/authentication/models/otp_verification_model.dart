import 'package:equatable/equatable.dart';

import '../enums/otp_type.dart';

/// OTP verification model.
///
/// Represents the data required to verify an OTP.
class OtpVerificationModel extends Equatable {
  /// Email address
  final String? email;

  /// Phone number
  final String? phone;

  /// OTP code
  final String otp;

  /// OTP type
  final OtpType type;

  /// User ID
  final String? userId;

  /// Session ID
  final String? sessionId;

  const OtpVerificationModel({
    this.email,
    this.phone,
    required this.otp,
    required this.type,
    this.userId,
    this.sessionId,
  });

  /// Creates a copy with updated fields.
  OtpVerificationModel copyWith({
    String? email,
    String? phone,
    String? otp,
    OtpType? type,
    String? userId,
    String? sessionId,
  }) {
    return OtpVerificationModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  /// Creates an OTP verification for email.
  factory OtpVerificationModel.forEmail({
    required String email,
    required String otp,
    required OtpType type,
    String? userId,
  }) {
    return OtpVerificationModel(
      email: email,
      otp: otp,
      type: type,
      userId: userId,
    );
  }

  /// Creates an OTP verification for phone.
  factory OtpVerificationModel.forPhone({
    required String phone,
    required String otp,
    required OtpType type,
    String? userId,
  }) {
    return OtpVerificationModel(
      phone: phone,
      otp: otp,
      type: type,
      userId: userId,
    );
  }

  /// Returns true if the request has an email.
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Returns true if the request has a phone number.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  /// Returns true if the OTP is valid length.
  bool get isValidLength => otp.length >= 6;

  @override
  List<Object?> get props => [
        email,
        phone,
        otp,
        type,
        userId,
        sessionId,
      ];
}
