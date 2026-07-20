import 'package:equatable/equatable.dart';

/// Register request model.
///
/// Represents the data required to create a new user account.
class RegisterRequestModel extends Equatable {
  /// User email address
  final String email;

  /// User password
  final String password;

  /// User display name
  final String? displayName;

  /// User phone number
  final String? phone;

  /// Username
  final String? username;

  /// Accept terms and conditions
  final bool acceptTerms;

  /// Accept privacy policy
  final bool acceptPrivacy;

  /// Device ID
  final String? deviceId;

  /// FCM token for push notifications
  final String? fcmToken;

  const RegisterRequestModel({
    required this.email,
    required this.password,
    this.displayName,
    this.phone,
    this.username,
    this.acceptTerms = true,
    this.acceptPrivacy = true,
    this.deviceId,
    this.fcmToken,
  });

  /// Creates a copy with updated fields.
  RegisterRequestModel copyWith({
    String? email,
    String? password,
    String? displayName,
    String? phone,
    String? username,
    bool? acceptTerms,
    bool? acceptPrivacy,
    String? deviceId,
    String? fcmToken,
  }) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      acceptPrivacy: acceptPrivacy ?? this.acceptPrivacy,
      deviceId: deviceId ?? this.deviceId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  /// Returns true if all required consents are provided.
  bool get hasAllConsents => acceptTerms && acceptPrivacy;

  /// Returns true if the user has provided a display name.
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Returns true if the user has provided a phone number.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        password,
        displayName,
        phone,
        username,
        acceptTerms,
        acceptPrivacy,
        deviceId,
        fcmToken,
      ];
}
