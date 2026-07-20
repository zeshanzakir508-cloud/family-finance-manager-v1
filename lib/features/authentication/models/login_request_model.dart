import 'package:equatable/equatable.dart';

import '../enums/login_method.dart';

/// Login request model.
///
/// Represents the data required to authenticate a user.
class LoginRequestModel extends Equatable {
  /// Email address
  final String? email;

  /// Password
  final String? password;

  /// Phone number
  final String? phone;

  /// OTP code
  final String? otp;

  /// Login method
  final LoginMethod method;

  /// Remember me flag
  final bool rememberMe;

  /// Device ID
  final String? deviceId;

  /// Device name
  final String? deviceName;

  /// FCM token for push notifications
  final String? fcmToken;

  const LoginRequestModel({
    this.email,
    this.password,
    this.phone,
    this.otp,
    required this.method,
    this.rememberMe = false,
    this.deviceId,
    this.deviceName,
    this.fcmToken,
  });

  /// Creates an email/password login request.
  factory LoginRequestModel.emailPassword({
    required String email,
    required String password,
    bool rememberMe = false,
    String? deviceId,
    String? deviceName,
    String? fcmToken,
  }) {
    return LoginRequestModel(
      email: email,
      password: password,
      method: LoginMethod.emailPassword,
      rememberMe: rememberMe,
      deviceId: deviceId,
      deviceName: deviceName,
      fcmToken: fcmToken,
    );
  }

  /// Creates a Google login request.
  factory LoginRequestModel.google({
    required String idToken,
    bool rememberMe = false,
    String? deviceId,
    String? deviceName,
    String? fcmToken,
  }) {
    return LoginRequestModel(
      password: idToken,
      method: LoginMethod.google,
      rememberMe: rememberMe,
      deviceId: deviceId,
      deviceName: deviceName,
      fcmToken: fcmToken,
    );
  }

  /// Creates an OTP login request.
  factory LoginRequestModel.otp({
    required String phone,
    required String otp,
    bool rememberMe = false,
    String? deviceId,
    String? deviceName,
    String? fcmToken,
  }) {
    return LoginRequestModel(
      phone: phone,
      otp: otp,
      method: LoginMethod.phone,
      rememberMe: rememberMe,
      deviceId: deviceId,
      deviceName: deviceName,
      fcmToken: fcmToken,
    );
  }

  /// Creates a biometric login request.
  factory LoginRequestModel.biometric({
    required String userId,
    bool rememberMe = false,
    String? deviceId,
    String? deviceName,
    String? fcmToken,
  }) {
    return LoginRequestModel(
      email: userId,
      method: LoginMethod.biometric,
      rememberMe: rememberMe,
      deviceId: deviceId,
      deviceName: deviceName,
      fcmToken: fcmToken,
    );
  }

  /// Returns true if the request has a password.
  bool get hasPassword => password != null && password!.isNotEmpty;

  /// Returns true if the request has an email.
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Returns true if the request has a phone number.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  /// Returns true if the request has an OTP.
  bool get hasOtp => otp != null && otp!.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        password,
        phone,
        otp,
        method,
        rememberMe,
        deviceId,
        deviceName,
        fcmToken,
      ];
}
