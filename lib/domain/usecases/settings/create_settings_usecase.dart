import '../../../repositories/settings_repository.dart';
import '../../dto/settings/create_settings_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/settings_validator.dart';

/// ============================================================================
/// Family Finance Manager
/// Create Settings UseCase
/// ----------------------------------------------------------------------------
/// Creates application settings.
/// ============================================================================
class CreateSettingsUseCase
    implements UseCase<void, CreateSettingsRequest> {
  final SettingsRepository _repository;
  final SettingsValidator _validator;

  const CreateSettingsUseCase({
    required SettingsRepository repository,
    required SettingsValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateSettingsRequest params) async {
    _validator.validate(params);

    await _repository.createSettings(
      params.settings,
    );
  }
}
