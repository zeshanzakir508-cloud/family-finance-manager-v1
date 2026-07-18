// lib/domain/entities/auth_session.dart

import 'package:equatable/equatable.dart';

import '../enums/auth_provider.dart';

/// Auth session entity representing a user's authentication session.
///
/// This entity tracks the current authentication session including
/// tokens, expiration, and provider information.
class AuthSession extends Equatable {
  /// Unique identifier for the user.
  final String userId;

  /// User's email address.
  final String? email;

  /// User's display name.
  final String? displayName;

  /// URL to the user's profile photo.
  final String? photoUrl;

  /// ID token for authentication.
  final String idToken;

  /// Refresh token for obtaining new ID tokens.
  final String refreshToken;

  /// Expiration time of the ID token.
  final DateTime expiresAt;

  /// Whether the user is anonymous.
  final bool isAnonymous;

  /// List of authentication providers used.
  final List<AuthProvider> providers;

  const AuthSession({
    required this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.idToken,
    required this.refreshToken,
    required this.expiresAt,
    this.isAnonymous = false,
    this.providers = const [],
  }) : assert(userId.isNotEmpty, 'User ID cannot be empty');

  /// Creates a copy of this auth session with the given fields replaced.
  AuthSession copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? idToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool? isAnonymous,
    List<AuthProvider>? providers,
  }) {
    return AuthSession(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      idToken: idToken ?? this.idToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      providers: providers ?? this.providers,
    );
  }

  /// Checks if the session is expired at the given time.
  bool isExpiredAt(DateTime currentTime) {
    return currentTime.isAfter(expiresAt);
  }

  /// Returns whether the session is still valid at the given time.
  bool isValidAt(DateTime currentTime) {
    return !isExpiredAt(currentTime);
  }

  /// Returns whether the user has a display name.
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Returns whether the user has a profile photo.
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Returns whether the user has an email address.
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Returns the number of providers linked to this session.
  int get providerCount => providers.length;

  /// Returns whether the session has multiple providers.
  bool get hasMultipleProviders => providers.length > 1;

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        photoUrl,
        idToken,
        refreshToken,
        expiresAt,
        isAnonymous,
        providers,
      ];
}
