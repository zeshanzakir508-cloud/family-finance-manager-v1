import '../../../repositories/family_repository.dart';
import '../../dto/family/update_family_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/family_validator.dart';

class UpdateFamilyUseCase
    implements UseCase<void, UpdateFamilyRequest> {
  final FamilyRepository _repository;
  final FamilyValidator _validator;

  const UpdateFamilyUseCase({
    required FamilyRepository repository,
    required FamilyValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateFamilyRequest params) async {
    _validator.validate(params);

    final exists = await _repository.familyExists(
      params.family.id,
    );

    if (!exists) {
      throw const NotFoundException(
        'Family not found.',
      );
    }

    await _repository.updateFamily(
      params.family,
    );
  }
}
