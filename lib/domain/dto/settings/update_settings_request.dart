import '../../../models/app_settings_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Update Settings Request
/// ----------------------------------------------------------------------------
/// Request object used when updating application settings.
/// ============================================================================
class UpdateSettingsRequest {
  /// Updated application settings.
  final AppSettingsModel settings;

  const UpdateSettingsRequest({
    required this.settings,
  });
}
