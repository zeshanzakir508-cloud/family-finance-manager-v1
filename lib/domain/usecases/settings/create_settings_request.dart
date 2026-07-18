import '../../../models/app_settings_model.dart';

/// Request object for creating application settings.
class CreateSettingsRequest {
  final AppSettingsModel settings;

  const CreateSettingsRequest({
    required this.settings,
  });
}
