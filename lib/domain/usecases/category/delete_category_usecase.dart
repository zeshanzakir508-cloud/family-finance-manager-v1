import '../../../repositories/category_repository.dart';
import '../../dto/category/delete_category_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class DeleteCategoryUseCase
    implements UseCase<void, DeleteCategoryRequest> {
  final CategoryRepository _repository;

  const DeleteCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteCategoryRequest params) async {
    final exists = await _repository.categoryExists(
      params.categoryId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Category not found.',
      );
    }

    await _repository.deleteCategory(
      params.categoryId,
    );
  }
}
