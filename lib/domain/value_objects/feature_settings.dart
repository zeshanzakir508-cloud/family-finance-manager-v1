// lib/domain/value_objects/feature_settings.dart

import 'package:equatable/equatable.dart';

/// Value object representing feature toggles.
class FeatureSettings extends Equatable {
  /// Whether budget tracking is enabled.
  final bool budgetTracking;

  /// Whether recurring transactions are enabled.
  final bool recurringTransactions;

  /// Whether split transactions are enabled.
  final bool splitTransactions;

  /// Whether family sharing is enabled.
  final bool familySharing;

  /// Whether reports and analytics are enabled.
  final bool reports;

  /// Whether export functionality is enabled.
  final bool exportEnabled;

  const FeatureSettings({
    this.budgetTracking = true,
    this.recurringTransactions = true,
    this.splitTransactions = true,
    this.familySharing = true,
    this.reports = true,
    this.exportEnabled = true,
  });

  /// Creates a copy of this feature settings with the given fields replaced.
  FeatureSettings copyWith({
    bool? budgetTracking,
    bool? recurringTransactions,
    bool? splitTransactions,
    bool? familySharing,
    bool? reports,
    bool? exportEnabled,
  }) {
    return FeatureSettings(
      budgetTracking: budgetTracking ?? this.budgetTracking,
      recurringTransactions:
          recurringTransactions ?? this.recurringTransactions,
      splitTransactions: splitTransactions ?? this.splitTransactions,
      familySharing: familySharing ?? this.familySharing,
      reports: reports ?? this.reports,
      exportEnabled: exportEnabled ?? this.exportEnabled,
    );
  }

  /// Returns whether any features are enabled.
  bool get hasAnyFeatures =>
      budgetTracking ||
      recurringTransactions ||
      splitTransactions ||
      familySharing ||
      reports ||
      exportEnabled;

  /// Returns whether all features are enabled.
  bool get hasAllFeatures =>
      budgetTracking &&
      recurringTransactions &&
      splitTransactions &&
      familySharing &&
      reports &&
      exportEnabled;

  @override
  List<Object?> get props => [
        budgetTracking,
        recurringTransactions,
        splitTransactions,
        familySharing,
        reports,
        exportEnabled,
      ];
}
