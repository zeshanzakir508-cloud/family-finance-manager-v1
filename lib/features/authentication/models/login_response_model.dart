import 'package:equatable/equatable.dart';

import 'auth_session_model.dart';

/// Login response model.
///
/// Represents the response received after a successful login attempt.
class LoginResponseModel extends Equatable {
  /// User ID
  final String userId;

  /// User email
  final String? email;

  /// User display name
  final String? displayName;

  /// Authentication session
  final AuthSessionModel session;

  /// Whether email is verified
  final bool isEmailVerified;

  /// Whether account is active
  final bool isActive;

  /// Account creation timestamp
  final DateTime? createdAt;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  /// User role
  final String? role;

  /// Profile image URL
  final String? photoUrl;

  const LoginResponseModel({
    required this.userId,
    this.email,
    this.displayName,
    required this.session,
    this.isEmailVerified = false,
    this.isActive = true,
    this.createdAt,
    this.lastLoginAt,
    this.role,
    this.photoUrl,
  });

  /// Creates a copy with updated fields.
  LoginResponseModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    AuthSessionModel? session,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? role,
    String? photoUrl,
  }) {
    return LoginResponseModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      session: session ?? this.session,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  /// Returns true if the user has a complete profile.
  bool get hasCompleteProfile =>
      displayName != null && displayName!.isNotEmpty;

  /// Returns true if the user can access full features.
  bool get canAccessFullFeatures => isActive && isEmailVerified;

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        session,
        isEmailVerified,
        isActive,
        createdAt,
        lastLoginAt,
        role,
        photoUrl,
      ];
}
