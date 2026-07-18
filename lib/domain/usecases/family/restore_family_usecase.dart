import '../../../repositories/family_repository.dart';
import '../../dto/family/restore_family_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class RestoreFamilyUseCase
    implements UseCase<void, RestoreFamilyRequest> {
  final FamilyRepository _repository;

  const RestoreFamilyUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RestoreFamilyRequest params,
  ) async {
    final exists = await _repository.familyExists(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Family not found.',
      );
    }

    await _repository.restoreFamily(
      params.familyId,
    );
  }
}
