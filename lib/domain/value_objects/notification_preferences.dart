// lib/domain/value_objects/notification_preferences.dart

import 'package:equatable/equatable.dart';

/// Value object representing user notification preferences.
class NotificationPreferences extends Equatable {
  /// Whether push notifications are enabled.
  final bool pushEnabled;

  /// Whether email notifications are enabled.
  final bool emailEnabled;

  /// Whether expense alerts are enabled.
  final bool expenseAlerts;

  /// Whether recurring transaction reminders are enabled.
  final bool recurringReminders;

  /// Whether family activity notifications are enabled.
  final bool familyActivity;

  /// Whether weekly reports are enabled.
  final bool weeklyReports;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.expenseAlerts = true,
    this.recurringReminders = true,
    this.familyActivity = true,
    this.weeklyReports = true,
  });

  /// Creates a copy of this notification preferences with the given fields replaced.
  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? expenseAlerts,
    bool? recurringReminders,
    bool? familyActivity,
    bool? weeklyReports,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      expenseAlerts: expenseAlerts ?? this.expenseAlerts,
      recurringReminders: recurringReminders ?? this.recurringReminders,
      familyActivity: familyActivity ?? this.familyActivity,
      weeklyReports: weeklyReports ?? this.weeklyReports,
    );
  }

  /// Returns whether any notifications are enabled.
  bool get hasAnyEnabled =>
      pushEnabled ||
      emailEnabled ||
      expenseAlerts ||
      recurringReminders ||
      familyActivity ||
      weeklyReports;

  /// Returns whether push notifications are enabled.
  bool get hasPushEnabled => pushEnabled;

  /// Returns whether email notifications are enabled.
  bool get hasEmailEnabled => emailEnabled;

  @override
  List<Object?> get props => [
        pushEnabled,
        emailEnabled,
        expenseAlerts,
        recurringReminders,
        familyActivity,
        weeklyReports,
      ];
}
