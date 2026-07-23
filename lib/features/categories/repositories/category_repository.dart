import '../services/category_service.dart';
import '../validators/category_validator.dart';

/// Repository for category data operations
class CategoryRepository {
  final CategoryService _service;

  CategoryRepository(this._service);

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    return await _service.getCategories();
  }

  /// Get categories by family ID
  Future<List<CategoryModel>> getCategoriesByFamily(String familyId) async {
    return await _service.getCategoriesByFamily(familyId);
  }

  /// Get a category by ID
  Future<CategoryModel> getCategory(String categoryId) async {
    return await _service.getCategory(categoryId);
  }

  /// Create a new category
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    String icon = 'category',
    String color = '#45B7D1',
    String? familyId,
  }) async {
    // Validate name
    final nameValidation = CategoryValidator.validateName(name);
    if (!nameValidation.isValid) {
      throw Exception(nameValidation.message);
    }

    // Validate description
    final descValidation = CategoryValidator.validateDescription(description);
    if (!descValidation.isValid) {
      throw Exception(descValidation.message);
    }

    // Check for duplicate name
    final existingCategories = await _service.getCategories();
    final duplicateValidation = CategoryValidator.validateDuplicateName(
      name,
      existingCategories,
    );
    if (!duplicateValidation.isValid) {
      throw Exception(duplicateValidation.message);
    }

    return await _service.createCategory(
      name: name,
      description: description,
      icon: icon,
      color: color,
      familyId: familyId,
    );
  }

  /// Update an existing category
  Future<CategoryModel> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    String? icon,
    String? color,
  }) async {
    // Get existing category
    final existingCategory = await _service.getCategory(categoryId);

    // Validate name if provided
    if (name != null) {
      final nameValidation = CategoryValidator.validateName(name);
      if (!nameValidation.isValid) {
        throw Exception(nameValidation.message);
      }

      // Check for duplicate name
      final existingCategories = await _service.getCategories();
      final duplicateValidation = CategoryValidator.validateDuplicateName(
        name,
        existingCategories,
        excludeId: categoryId,
      );
      if (!duplicateValidation.isValid) {
        throw Exception(duplicateValidation.message);
      }
    }

    // Validate description if provided
    if (description != null) {
      final descValidation = CategoryValidator.validateDescription(description);
      if (!descValidation.isValid) {
        throw Exception(descValidation.message);
      }
    }

    return await _service.updateCategory(
      categoryId: categoryId,
      name: name,
      description: description,
      icon: icon,
      color: color,
    );
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    // Get existing category
    final category = await _service.getCategory(categoryId);

    // Check if category has transactions
    final hasTransactions = await _service.hasTransactions(categoryId);
    
    // Validate deletion
    final validation = CategoryValidator.validateDeleteCategory(
      category,
      hasTransactions,
    );
    if (!validation.isValid) {
      throw Exception(validation.message);
    }

    await _service.deleteCategory(categoryId);
  }

  /// Archive a category
  Future<void> archiveCategory(String categoryId) async {
    await _service.archiveCategory(categoryId);
  }

  /// Restore an archived category
  Future<void> restoreCategory(String categoryId) async {
    await _service.restoreCategory(categoryId);
  }

  /// Merge categories
  Future<void> mergeCategories({
    required String sourceCategoryId,
    required String targetCategoryId,
  }) async {
    // Get categories
    final sourceCategory = await _service.getCategory(sourceCategoryId);
    final targetCategory = await _service.getCategory(targetCategoryId);

    // Validate merge
    final validation = CategoryValidator.validateMergeCategories(
      sourceCategory,
      targetCategory,
    );
    if (!validation.isValid) {
      throw Exception(validation.message);
    }

    await _service.mergeCategories(
      sourceCategoryId: sourceCategoryId,
      targetCategoryId: targetCategoryId,
    );
  }

  /// Search categories
  Future<List<CategoryModel>> searchCategories(String query) async {
    return await _service.searchCategories(query);
  }

  /// Filter categories
  Future<List<CategoryModel>> filterCategories(String filter) async {
    return await _service.filterCategories(filter);
  }

  /// Get category count
  Future<int> getCategoryCount() async {
    return await _service.getCategoryCount();
  }

  /// Get active category count
  Future<int> getActiveCategoryCount() async {
    return await _service.getActiveCategoryCount();
  }

  /// Get archived category count
  Future<int> getArchivedCategoryCount() async {
    return await _service.getArchivedCategoryCount();
  }

  /// Check if category has transactions
  Future<bool> hasTransactions(String categoryId) async {
    return await _service.hasTransactions(categoryId);
  }

  /// Get categories with transaction counts
  Future<List<Map<String, dynamic>>> getCategoriesWithCounts() async {
    return await _service.getCategoriesWithCounts();
  }

  /// Get category by name
  Future<CategoryModel?> getCategoryByName(String name) async {
    return await _service.getCategoryByName(name);
  }

  /// Check if category name exists
  Future<bool> categoryNameExists(String name, {String? excludeId}) async {
    return await _service.categoryNameExists(name, excludeId: excludeId);
  }

  /// Get category statistics
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    return await _service.getCategoryStatistics();
  }

  /// Sync categories with server
  Future<void> syncCategories() async {
    await _service.syncCategories();
  }

  /// Watch categories changes
  Stream<List<CategoryModel>> watchCategories() {
    return _service.watchCategories();
  }

  /// Watch categories changes by family
  Stream<List<CategoryModel>> watchCategoriesByFamily(String familyId) {
    return _service.watchCategoriesByFamily(familyId);
  }
}
