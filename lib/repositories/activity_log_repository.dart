import '../models/activity_log_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Activity Log Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing activity logs (audit trail).
///
/// Responsibilities:
/// • Create activity logs
/// • Read activity log(s)
/// • Watch activity logs
/// • Filter activity logs
/// • Search activity logs
/// • Reporting support
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class ActivityLogRepository {
  //==========================================================================
  // Activity Log
  //==========================================================================

  /// Creates a new activity log.
  Future<void> createActivityLog(ActivityLogModel activityLog);

  /// Returns an activity log by its ID.
  Future<ActivityLogModel?> getActivityLog(String activityLogId);

  /// Returns all activity logs for a family.
  Future<List<ActivityLogModel>> getActivityLogs(
    String familyId,
  );

  /// Watches a single activity log.
  Stream<ActivityLogModel?> watchActivityLog(
    String activityLogId,
  );

  /// Watches all activity logs of a family.
  Stream<List<ActivityLogModel>> watchActivityLogs(
    String familyId,
  );

  //==========================================================================
  // User Filters
  //==========================================================================

  /// Returns all activity logs created by a user.
  Future<List<ActivityLogModel>> getActivityLogsByUser({
    required String familyId,
    required String userId,
  });

  /// Watches all activity logs created by a user.
  Stream<List<ActivityLogModel>> watchActivityLogsByUser({
    required String familyId,
    required String userId,
  });

  //==========================================================================
  // Activity Type Filters
  //==========================================================================

  /// Returns activity logs by activity type.
  Future<List<ActivityLogModel>> getActivityLogsByType({
    required String familyId,
    required String activityType,
  });

  /// Watches activity logs by activity type.
  Stream<List<ActivityLogModel>> watchActivityLogsByType({
    required String familyId,
    required String activityType,
  });

  //==========================================================================
  // Date Filters
  //==========================================================================

  /// Returns activity logs within the specified date range.
  Future<List<ActivityLogModel>> getActivityLogsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Watches activity logs within the specified date range.
  Stream<List<ActivityLogModel>> watchActivityLogsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
  });

  //==========================================================================
  // Search
  //==========================================================================

  /// Searches activity logs by keyword.
  Future<List<ActivityLogModel>> searchActivityLogs({
    required String familyId,
    required String keyword,
  });

  //==========================================================================
  // Maintenance
  //==========================================================================

  /// Deletes activity logs older than the specified date.
  ///
  /// Intended for cleanup jobs if log retention is enabled.
  Future<void> deleteActivityLogsBefore(
    DateTime date,
  );
}
