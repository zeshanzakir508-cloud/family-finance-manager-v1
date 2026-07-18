import '../../../repositories/settings_repository.dart';
import '../../dto/settings/reset_settings_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

/// ============================================================================
/// Family Finance Manager
/// Reset Settings UseCase
/// ----------------------------------------------------------------------------
/// Restores application settings to their default values.
/// ============================================================================
class ResetSettingsUseCase
    implements UseCase<void, ResetSettingsRequest> {
  final SettingsRepository _repository;

  const ResetSettingsUseCase({
    required SettingsRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(ResetSettingsRequest params) async {
    final exists = await _repository.settingsExist(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Settings not found.',
      );
    }

    await _repository.resetSettings(
      params.familyId,
    );
  }
}
