import 'package:equatable/equatable.dart';

/// Remember me model.
///
/// Represents the data required for "Remember Me" functionality.
class RememberMeModel extends Equatable {
  /// User email
  final String email;

  /// User password (encrypted)
  final String? encryptedPassword;

  /// User ID
  final String? userId;

  /// Remember me token
  final String? token;

  /// Whether remember me is enabled
  final bool enabled;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  /// Device ID
  final String? deviceId;

  const RememberMeModel({
    required this.email,
    this.encryptedPassword,
    this.userId,
    this.token,
    this.enabled = true,
    this.lastLoginAt,
    this.deviceId,
  });

  /// Creates a copy with updated fields.
  RememberMeModel copyWith({
    String? email,
    String? encryptedPassword,
    String? userId,
    String? token,
    bool? enabled,
    DateTime? lastLoginAt,
    String? deviceId,
  }) {
    return RememberMeModel(
      email: email ?? this.email,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      enabled: enabled ?? this.enabled,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  /// Creates an empty model.
  factory RememberMeModel.empty() {
    return RememberMeModel(
      email: '',
      enabled: false,
    );
  }

  /// Creates a model for saving credentials.
  factory RememberMeModel.saveCredentials({
    required String email,
    required String encryptedPassword,
    String? userId,
    String? deviceId,
  }) {
    return RememberMeModel(
      email: email,
      encryptedPassword: encryptedPassword,
      userId: userId,
      deviceId: deviceId,
      enabled: true,
      lastLoginAt: DateTime.now(),
    );
  }

  /// Creates a model for token-based remember me.
  factory RememberMeModel.withToken({
    required String email,
    required String token,
    String? userId,
    String? deviceId,
  }) {
    return RememberMeModel(
      email: email,
      token: token,
      userId: userId,
      deviceId: deviceId,
      enabled: true,
      lastLoginAt: DateTime.now(),
    );
  }

  /// Returns true if credentials are stored.
  bool get hasCredentials => encryptedPassword != null && encryptedPassword!.isNotEmpty;

  /// Returns true if token is stored.
  bool get hasToken => token != null && token!.isNotEmpty;

  /// Returns true if remember me is active and valid.
  bool get isValid => enabled && (hasCredentials || hasToken);

  @override
  List<Object?> get props => [
        email,
        encryptedPassword,
        userId,
        token,
        enabled,
        lastLoginAt,
        deviceId,
      ];
}
