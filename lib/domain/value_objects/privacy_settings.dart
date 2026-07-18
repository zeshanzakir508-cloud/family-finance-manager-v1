// lib/domain/value_objects/privacy_settings.dart

import 'package:equatable/equatable.dart';

/// Value object representing user privacy settings.
class PrivacySettings extends Equatable {
  /// Whether the user's profile is visible to others.
  final bool profileVisible;

  /// Whether the user's transaction data is shared for analytics.
  final bool shareAnalytics;

  /// Whether the user's balance is shown in the app.
  final bool showBalance;

  /// Whether the user's transaction descriptions are visible to family.
  final bool shareDescriptions;

  /// Whether the user's spending data is included in family reports.
  final bool includeInFamilyReports;

  const PrivacySettings({
    this.profileVisible = true,
    this.shareAnalytics = false,
    this.showBalance = true,
    this.shareDescriptions = true,
    this.includeInFamilyReports = true,
  });

  /// Creates a copy of this privacy settings with the given fields replaced.
  PrivacySettings copyWith({
    bool? profileVisible,
    bool? shareAnalytics,
    bool? showBalance,
    bool? shareDescriptions,
    bool? includeInFamilyReports,
  }) {
    return PrivacySettings(
      profileVisible: profileVisible ?? this.profileVisible,
      shareAnalytics: shareAnalytics ?? this.shareAnalytics,
      showBalance: showBalance ?? this.showBalance,
      shareDescriptions: shareDescriptions ?? this.shareDescriptions,
      includeInFamilyReports:
          includeInFamilyReports ?? this.includeInFamilyReports,
    );
  }

  /// Returns whether the user has a public profile.
  bool get isProfilePublic => profileVisible;

  /// Returns whether the user is sharing analytics data.
  bool get isSharingAnalytics => shareAnalytics;

  /// Returns whether the user's balance is visible.
  bool get isBalanceVisible => showBalance;

  /// Returns whether the user's descriptions are shared with family.
  bool get areDescriptionsShared => shareDescriptions;

  /// Returns whether the user is included in family reports.
  bool get isIncludedInFamilyReports => includeInFamilyReports;

  @override
  List<Object?> get props => [
        profileVisible,
        shareAnalytics,
        showBalance,
        shareDescriptions,
        includeInFamilyReports,
      ];
}
