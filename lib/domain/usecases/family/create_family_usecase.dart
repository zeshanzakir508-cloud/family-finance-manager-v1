import '../../../repositories/family_repository.dart';
import '../../dto/family/create_family_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/family_validator.dart';

class CreateFamilyUseCase
    implements UseCase<void, CreateFamilyRequest> {
  final FamilyRepository _repository;
  final FamilyValidator _validator;

  const CreateFamilyUseCase({
    required FamilyRepository repository,
    required FamilyValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateFamilyRequest params) async {
    _validator.validate(params);

    await _repository.createFamily(
      params.family,
    );
  }
}
