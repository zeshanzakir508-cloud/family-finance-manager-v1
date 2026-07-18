// lib/domain/entities/user.dart

import 'package:equatable/equatable.dart';

import '../value_objects/notification_preferences.dart';
import '../value_objects/privacy_settings.dart';
import '../enums/theme_preference.dart';

/// User entity representing an application user.
///
/// This is a domain entity that contains only business-relevant fields.
/// Persistence-managed fields like [id], [createdAt], and [updatedAt]
/// are handled by the data layer.
class User extends Equatable {
  /// Unique identifier for the user.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// User's email address.
  final String email;

  /// User's display name.
  final String displayName;

  /// URL to the user's profile photo.
  final String? photoUrl;

  /// Whether the user's email is verified.
  final bool emailVerified;

  /// Whether the user is anonymous.
  final bool isAnonymous;

  /// Whether the user account is active.
  final bool isActive;

  /// Whether the user has completed onboarding.
  final bool onboardingComplete;

  /// User's phone number (optional).
  final String? phoneNumber;

  /// Preferred language of the user.
  final String? preferredLanguage;

  /// Time zone of the user.
  final String? timeZone;

  /// User's theme preference.
  final ThemePreference? themePreference;

  /// User's notification preferences.
  final NotificationPreferences? notificationPreferences;

  /// User's privacy settings.
  final PrivacySettings? privacySettings;

  const User({
    this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.isAnonymous = false,
    this.isActive = true,
    this.onboardingComplete = false,
    this.phoneNumber,
    this.preferredLanguage,
    this.timeZone,
    this.themePreference,
    this.notificationPreferences,
    this.privacySettings,
  });

  /// Creates a copy of this user with the given fields replaced.
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    bool? isAnonymous,
    bool? isActive,
    bool? onboardingComplete,
    String? phoneNumber,
    String? preferredLanguage,
    String? timeZone,
    ThemePreference? themePreference,
    NotificationPreferences? notificationPreferences,
    PrivacySettings? privacySettings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isActive: isActive ?? this.isActive,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      timeZone: timeZone ?? this.timeZone,
      themePreference: themePreference ?? this.themePreference,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  /// Returns the user's initials from their display name.
  String get initials {
    if (displayName.isEmpty) return '';
    final parts = displayName.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Returns whether the user has a profile photo.
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Returns whether the user has completed their profile.
  bool get hasCompleteProfile =>
      displayName.isNotEmpty && email.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        emailVerified,
        isAnonymous,
        isActive,
        onboardingComplete,
        phoneNumber,
        preferredLanguage,
        timeZone,
        themePreference,
        notificationPreferences,
        privacySettings,
      ];
}
