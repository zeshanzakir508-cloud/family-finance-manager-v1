import '../../../repositories/settings_repository.dart';
import '../../dto/settings/import_settings_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

/// ============================================================================
/// Family Finance Manager
/// Import Settings UseCase
/// ----------------------------------------------------------------------------
/// Imports application settings.
/// ============================================================================
class ImportSettingsUseCase
    implements UseCase<void, ImportSettingsRequest> {
  final SettingsRepository _repository;

  const ImportSettingsUseCase({
    required SettingsRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(ImportSettingsRequest params) async {
    final exists = await _repository.settingsExist(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Settings not found.',
      );
    }

    await _repository.importSettings(
      familyId: params.familyId,
      data: params.data,
    );
  }
}
