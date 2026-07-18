import '../../../repositories/family_repository.dart';
import '../../dto/family/delete_family_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class DeleteFamilyUseCase
    implements UseCase<void, DeleteFamilyRequest> {
  final FamilyRepository _repository;

  const DeleteFamilyUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteFamilyRequest params) async {
    final exists = await _repository.familyExists(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Family not found.',
      );
    }

    await _repository.deleteFamily(
      params.familyId,
    );
  }
}
