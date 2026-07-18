import '../../../repositories/category_repository.dart';
import '../../dto/category/create_category_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/category_validator.dart';

class CreateCategoryUseCase
    implements UseCase<void, CreateCategoryRequest> {
  final CategoryRepository _repository;
  final CategoryValidator _validator;

  const CreateCategoryUseCase({
    required CategoryRepository repository,
    required CategoryValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateCategoryRequest params) async {
    _validator.validate(params);

    await _repository.createCategory(
      params.category,
    );
  }
}
