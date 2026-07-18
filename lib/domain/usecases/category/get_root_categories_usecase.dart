// lib/domain/usecases/category/get_root_categories_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetRootCategoriesUseCase].
class GetRootCategoriesParams extends Equatable {
  final String userId;
  final bool includeArchived;

  const GetRootCategoriesParams({
    required this.userId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [userId, includeArchived];
}

/// Use case for getting root (top-level) categories for a user.
///
/// This use case handles retrieving all root categories (categories without a parent)
/// for a specific user, with optional filtering for archived categories.
class GetRootCategoriesUseCase {
  final CategoryRepository _repository;

  const GetRootCategoriesUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get root categories use case.
  ///
  /// [params] contains the user ID and whether to include archived categories.
  /// Returns a list of [Category]s that are root categories for the user.
  /// Throws [CategoryException] if validation fails or retrieval fails.
  Future<List<Category>> call(GetRootCategoriesParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const CategoryDataException('User ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    return _repository.getRootCategories(
      params.userId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
