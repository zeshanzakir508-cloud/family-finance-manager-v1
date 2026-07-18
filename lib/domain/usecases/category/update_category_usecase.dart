import '../../../repositories/category_repository.dart';
import '../../dto/category/update_category_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/category_validator.dart';

class UpdateCategoryUseCase
    implements UseCase<void, UpdateCategoryRequest> {
  final CategoryRepository _repository;
  final CategoryValidator _validator;

  const UpdateCategoryUseCase({
    required CategoryRepository repository,
    required CategoryValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateCategoryRequest params) async {
    _validator.validate(params);

    final exists = await _repository.categoryExists(
      params.category.id,
    );

    if (!exists) {
      throw const NotFoundException(
        'Category not found.',
      );
    }

    await _repository.updateCategory(
      params.category,
    );
  }
}
