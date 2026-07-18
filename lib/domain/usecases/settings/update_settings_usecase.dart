import '../../../repositories/settings_repository.dart';
import '../../dto/settings/update_settings_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/settings_validator.dart';

/// ============================================================================
/// Family Finance Manager
/// Update Settings UseCase
/// ----------------------------------------------------------------------------
/// Updates existing application settings.
/// ============================================================================
class UpdateSettingsUseCase
    implements UseCase<void, UpdateSettingsRequest> {
  final SettingsRepository _repository;
  final SettingsValidator _validator;

  const UpdateSettingsUseCase({
    required SettingsRepository repository,
    required SettingsValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateSettingsRequest params) async {
    _validator.validate(params);

    final exists = await _repository.settingsExist(
      params.settings.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Settings not found.',
      );
    }

    await _repository.updateSettings(
      params.settings,
    );
  }
}
