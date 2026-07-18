// lib/domain/usecases/category/get_child_categories_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetChildCategoriesUseCase].
class GetChildCategoriesParams extends Equatable {
  final String parentId;
  final bool includeArchived;

  const GetChildCategoriesParams({
    required this.parentId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [parentId, includeArchived];
}

/// Use case for getting child categories of a parent category.
///
/// This use case handles retrieving all child categories under a specific
/// parent category, with optional filtering for archived categories.
class GetChildCategoriesUseCase {
  final CategoryRepository _repository;

  const GetChildCategoriesUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get child categories use case.
  ///
  /// [params] contains the parent category ID and whether to include archived categories.
  /// Returns a list of [Category]s that are children of the parent.
  /// Throws [CategoryException] if validation fails or retrieval fails.
  Future<List<Category>> call(GetChildCategoriesParams params) async {
    // Business rule: parent ID must not be empty
    if (params.parentId.trim().isEmpty) {
      throw const CategoryDataException('Parent category ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    return _repository.getChildCategories(
      params.parentId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
