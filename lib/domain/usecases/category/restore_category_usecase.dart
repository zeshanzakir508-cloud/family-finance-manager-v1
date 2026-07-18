import '../../../repositories/category_repository.dart';
import '../../dto/category/restore_category_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class RestoreCategoryUseCase
    implements UseCase<void, RestoreCategoryRequest> {
  final CategoryRepository _repository;

  const RestoreCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RestoreCategoryRequest params,
  ) async {
    final exists = await _repository.categoryExists(
      params.categoryId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Category not found.',
      );
    }

    await _repository.restoreCategory(
      params.categoryId,
    );
  }
}
