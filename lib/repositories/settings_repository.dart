import '../models/app_settings_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Settings Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing application settings.
///
/// Responsibilities:
/// • Create settings
/// • Read settings
/// • Update settings
/// • Watch settings changes
/// • Reset settings
/// • Import/Export settings (future)
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class SettingsRepository {
  //==========================================================================
  // Settings
  //==========================================================================

  /// Creates application settings.
  Future<void> createSettings(
    AppSettingsModel settings,
  );

  /// Returns application settings for a family.
  Future<AppSettingsModel?> getSettings(
    String familyId,
  );

  /// Watches application settings.
  Stream<AppSettingsModel?> watchSettings(
    String familyId,
  );

  /// Updates application settings.
  Future<void> updateSettings(
    AppSettingsModel settings,
  );

  /// Deletes application settings.
  Future<void> deleteSettings(
    String familyId,
  );

  /// Returns true if settings exist.
  Future<bool> settingsExist(
    String familyId,
  );

  //==========================================================================
  // Reset
  //==========================================================================

  /// Restores default settings.
  Future<void> resetSettings(
    String familyId,
  );

  //==========================================================================
  // Backup & Restore
  //==========================================================================

  /// Exports settings.
  ///
  /// Reserved for future backup functionality.
  Future<Map<String, dynamic>> exportSettings(
    String familyId,
  );

  /// Imports settings.
  ///
  /// Reserved for future restore functionality.
  Future<void> importSettings({
    required String familyId,
    required Map<String, dynamic> data,
  });

  //==========================================================================
  // Maintenance
  //==========================================================================

  /// Refreshes the latest settings.
  Future<AppSettingsModel?> refreshSettings(
    String familyId,
  );
}
