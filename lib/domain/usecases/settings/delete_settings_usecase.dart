import '../../../repositories/settings_repository.dart';
import '../../dto/settings/delete_settings_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

/// ============================================================================
/// Family Finance Manager
/// Delete Settings UseCase
/// ----------------------------------------------------------------------------
/// Deletes application settings.
/// ============================================================================
class DeleteSettingsUseCase
    implements UseCase<void, DeleteSettingsRequest> {
  final SettingsRepository _repository;

  const DeleteSettingsUseCase({
    required SettingsRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteSettingsRequest params) async {
    final exists = await _repository.settingsExist(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Settings not found.',
      );
    }

    await _repository.deleteSettings(
      params.familyId,
    );
  }
}
