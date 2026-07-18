// lib/domain/usecases/category/get_category_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetCategoryUseCase].
class GetCategoryParams extends Equatable {
  final String categoryId;

  const GetCategoryParams({
    required this.categoryId,
  });

  @override
  List<Object?> get props => [categoryId];
}

/// Use case for getting a single category by ID.
///
/// This use case handles retrieving a specific category by its ID.
/// It validates the input before delegating to the repository.
class GetCategoryUseCase {
  final CategoryRepository _repository;

  const GetCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get category use case.
  ///
  /// [params] contains the category ID to retrieve.
  /// Returns the [Category] if found.
  /// Throws [CategoryException] if validation fails or category not found.
  Future<Category> call(GetCategoryParams params) async {
    // Business rule: category ID must not be empty
    if (params.categoryId.trim().isEmpty) {
      throw const CategoryDataException('Category ID cannot be empty.');
    }

    // Delegate to repository
    return _repository.getCategory(params.categoryId.trim());
  }
}
