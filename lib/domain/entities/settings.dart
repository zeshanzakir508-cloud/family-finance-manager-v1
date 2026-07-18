// lib/domain/entities/settings.dart

import 'package:equatable/equatable.dart';

import '../value_objects/notification_preferences.dart';
import '../value_objects/privacy_settings.dart';
import '../value_objects/security_settings.dart';
import '../value_objects/appearance_settings.dart';
import '../value_objects/feature_settings.dart';

/// Settings entity representing user application settings.
///
/// This entity contains user preferences for the application including
/// language, currency, and various preference groups.
class Settings extends Equatable {
  /// User ID (used as document ID in Firestore).
  final String userId;

  /// Language preference (e.g., 'en', 'es', 'fr').
  final String language;

  /// Currency preference (ISO code, e.g., 'USD', 'EUR').
  final String currency;

  /// Notification preferences.
  final NotificationPreferences notifications;

  /// Privacy settings.
  final PrivacySettings privacy;

  /// Security preferences.
  final SecuritySettings security;

  /// Appearance preferences.
  final AppearanceSettings appearance;

  /// Feature toggles.
  final FeatureSettings features;

  const Settings({
    required this.userId,
    this.language = 'en',
    this.currency = 'USD',
    this.notifications = const NotificationPreferences(),
    this.privacy = const PrivacySettings(),
    this.security = const SecuritySettings(),
    this.appearance = const AppearanceSettings(),
    this.features = const FeatureSettings(),
  });

  /// Creates a copy of these settings with the given fields replaced.
  Settings copyWith({
    String? userId,
    String? language,
    String? currency,
    NotificationPreferences? notifications,
    PrivacySettings? privacy,
    SecuritySettings? security,
    AppearanceSettings? appearance,
    FeatureSettings? features,
  }) {
    return Settings(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
      appearance: appearance ?? this.appearance,
      features: features ?? this.features,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        language,
        currency,
        notifications,
        privacy,
        security,
        appearance,
        features,
      ];
}
