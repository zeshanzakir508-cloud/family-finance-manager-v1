import '../../../models/app_settings_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Create Settings Request
/// ----------------------------------------------------------------------------
/// Request object used when creating application settings.
/// ============================================================================
class CreateSettingsRequest {
  /// Application settings.
  final AppSettingsModel settings;

  const CreateSettingsRequest({
    required this.settings,
  });
}
