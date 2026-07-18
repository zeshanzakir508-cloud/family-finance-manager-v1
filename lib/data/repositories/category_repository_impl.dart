// lib/data/repositories/category_repository_impl.dart

import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/exceptions/category_exceptions.dart';
import '../datasources/remote/firestore_category_data_source.dart';
import '../models/category_model.dart';

/// Implementation of [CategoryRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class CategoryRepositoryImpl implements CategoryRepository {
  final FirestoreCategoryDataSource _remoteDataSource;

  const CategoryRepositoryImpl({
    required FirestoreCategoryDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on CategoryException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const CategoryDataException('Unexpected repository error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream repository operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on CategoryException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const CategoryDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Category> getCategory(String categoryId) {
    return _execute(() async {
      final model = await _remoteDataSource.getCategory(categoryId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Category>> getCategoriesByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getCategoriesByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Category>> getCategoriesByType(CategoryType type) {
    return _execute(() async {
      final models = await _remoteDataSource.getCategoriesByType(type);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Category>> getCategoriesByFamilyId(String familyId) {
    return _execute(() async {
      final models = await _remoteDataSource.getCategoriesByFamilyId(familyId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Category> createCategory(Category category) {
    return _execute(() async {
      final model = CategoryModel.fromDomain(category);
      final createdModel = await _remoteDataSource.createCategory(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Category> updateCategory(Category category) {
    return _execute(() async {
      final model = CategoryModel.fromDomain(category);
      final updatedModel = await _remoteDataSource.updateCategory(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    return _execute(() async {
      await _remoteDataSource.deleteCategory(categoryId);
    });
  }

  @override
  Stream<Category> watchCategory(String categoryId) {
    return _executeStream(
      () => _remoteDataSource.watchCategory(categoryId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Category>> watchCategoriesByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchCategoriesByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Category>> watchCategoriesByType(CategoryType type) {
    return _executeStream(
      () => _remoteDataSource.watchCategoriesByType(type).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Category>> watchCategoriesByFamilyId(String familyId) {
    return _executeStream(
      () => _remoteDataSource.watchCategoriesByFamilyId(familyId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }
}
