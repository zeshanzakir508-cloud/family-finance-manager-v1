import '../../../models/app_settings_model.dart';

/// Request object for updating application settings.
class UpdateSettingsRequest {
  final AppSettingsModel settings;

  const UpdateSettingsRequest({
    required this.settings,
  });
}
