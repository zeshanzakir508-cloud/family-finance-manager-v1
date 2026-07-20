import 'package:equatable/equatable.dart';

/// Authentication session model.
///
/// Represents a user session with authentication tokens and metadata.
class AuthSessionModel extends Equatable {
  /// User ID
  final String userId;

  /// Access token
  final String accessToken;

  /// Refresh token
  final String? refreshToken;

  /// Token expiration time
  final DateTime expiresAt;

  /// Session creation time
  final DateTime createdAt;

  /// Session ID
  final String? sessionId;

  /// Device ID
  final String? deviceId;

  /// IP address
  final String? ipAddress;

  /// User agent
  final String? userAgent;

  /// Is session active
  final bool isActive;

  const AuthSessionModel({
    required this.userId,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    required this.createdAt,
    this.sessionId,
    this.deviceId,
    this.ipAddress,
    this.userAgent,
    this.isActive = true,
  });

  /// Creates a copy with updated fields.
  AuthSessionModel copyWith({
    String? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? createdAt,
    String? sessionId,
    String? deviceId,
    String? ipAddress,
    String? userAgent,
    bool? isActive,
  }) {
    return AuthSessionModel(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      sessionId: sessionId ?? this.sessionId,
      deviceId: deviceId ?? this.deviceId,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Returns true if the session is expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Returns true if the session is about to expire (within 5 minutes).
  bool get isExpiringSoon =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);

  /// Returns the remaining time until expiration.
  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  /// Creates a new session with fresh tokens.
  factory AuthSessionModel.newSession({
    required String userId,
    required String accessToken,
    String? refreshToken,
    Duration expiresIn = const Duration(minutes: 15),
  }) {
    final now = DateTime.now();
    return AuthSessionModel(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: now.add(expiresIn),
      createdAt: now,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        accessToken,
        refreshToken,
        expiresAt,
        createdAt,
        sessionId,
        deviceId,
        isActive,
      ];
}
