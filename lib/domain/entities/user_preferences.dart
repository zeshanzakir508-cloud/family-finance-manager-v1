// lib/domain/entities/user_preferences.dart

import 'package:equatable/equatable.dart';

import '../enums/dashboard_layout.dart';
import '../value_objects/chart_preferences.dart';
import '../value_objects/custom_category.dart';
import '../value_objects/report_preferences.dart';

/// User preferences entity representing user-specific preferences.
///
/// This entity contains user preferences for defaults, layout, and
/// application behavior that are specific to the user.
class UserPreferences extends Equatable {
  /// User ID (used as document ID in Firestore).
  final String userId;

  /// Default account ID for transactions.
  final String? defaultAccountId;

  /// Default category IDs for quick selection.
  final List<String>? defaultCategoryIds;

  /// Default family ID for family mode.
  final String? defaultFamilyId;

  /// Dashboard layout preference.
  final DashboardLayout dashboardLayout;

  /// Chart preferences.
  final ChartPreferences chartPreferences;

  /// Report preferences.
  final ReportPreferences reportPreferences;

  /// Custom categories created by the user.
  final List<CustomCategory>? customCategories;

  const UserPreferences({
    required this.userId,
    this.defaultAccountId,
    this.defaultCategoryIds,
    this.defaultFamilyId,
    this.dashboardLayout = DashboardLayout.defaultLayout,
    this.chartPreferences = const ChartPreferences(),
    this.reportPreferences = const ReportPreferences(),
    this.customCategories,
  }) : assert(userId.isNotEmpty, 'User ID cannot be empty');

  /// Creates a copy of these user preferences with the given fields replaced.
  UserPreferences copyWith({
    String? userId,
    String? defaultAccountId,
    List<String>? defaultCategoryIds,
    String? defaultFamilyId,
    DashboardLayout? dashboardLayout,
    ChartPreferences? chartPreferences,
    ReportPreferences? reportPreferences,
    List<CustomCategory>? customCategories,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      defaultAccountId: defaultAccountId ?? this.defaultAccountId,
      defaultCategoryIds: defaultCategoryIds ?? this.defaultCategoryIds,
      defaultFamilyId: defaultFamilyId ?? this.defaultFamilyId,
      dashboardLayout: dashboardLayout ?? this.dashboardLayout,
      chartPreferences: chartPreferences ?? this.chartPreferences,
      reportPreferences: reportPreferences ?? this.reportPreferences,
      customCategories: customCategories ?? this.customCategories,
    );
  }

  /// Returns whether the user has set a default account.
  bool get hasDefaultAccount => defaultAccountId != null && defaultAccountId!.isNotEmpty;

  /// Returns whether the user has set a default family.
  bool get hasDefaultFamily => defaultFamilyId != null && defaultFamilyId!.isNotEmpty;

  /// Returns whether the user has default categories.
  bool get hasDefaultCategories =>
      defaultCategoryIds != null && defaultCategoryIds!.isNotEmpty;

  /// Returns whether the user has custom categories.
  bool get hasCustomCategories =>
      customCategories != null && customCategories!.isNotEmpty;

  @override
  List<Object?> get props => [
        userId,
        defaultAccountId,
        defaultCategoryIds,
        defaultFamilyId,
        dashboardLayout,
        chartPreferences,
        reportPreferences,
        customCategories,
      ];
}
