import 'package:flutter/material.dart';
import '../repositories/category_repository.dart';
import '../validators/category_validator.dart';

/// Business logic controller for category management
class CategoryController extends ChangeNotifier {
  final CategoryRepository _repository;

  /// List of all categories
  List<CategoryModel> _categories = [];
  
  /// Currently selected category
  CategoryModel? _selectedCategory;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Search query
  String _searchQuery = '';
  
  /// Filter for categories (all, active, archived)
  String _filter = 'all';

  CategoryController(this._repository) {
    initialize();
  }

  // ============ Getters ============
  
  List<CategoryModel> get categories => _categories;
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get filter => _filter;
  
  /// Get filtered and searched categories
  List<CategoryModel> get filteredCategories {
    var filtered = _categories;
    
    // Apply filter
    if (_filter == 'active') {
      filtered = filtered.where((c) => !c.isArchived).toList();
    } else if (_filter == 'archived') {
      filtered = filtered.where((c) => c.isArchived).toList();
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) =>
        c.name.toLowerCase().contains(query) ||
        (c.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }
    
    return filtered;
  }
  
  /// Get active categories (not archived)
  List<CategoryModel> get activeCategories =>
      _categories.where((c) => !c.isArchived).toList();
  
  /// Get archived categories
  List<CategoryModel> get archivedCategories =>
      _categories.where((c) => c.isArchived).toList();

  // ============ Initialization ============
  
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      await loadCategories();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize categories: $e');
      _setLoading(false);
    }
  }

  // ============ Category Loading ============
  
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: $e');
      rethrow;
    }
  }

  Future<void> loadCategory(String categoryId) async {
    try {
      _selectedCategory = await _repository.getCategory(categoryId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load category: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadCategories();
    if (_selectedCategory != null) {
      await loadCategory(_selectedCategory!.id);
    }
  }

  // ============ Category CRUD Operations ============
  
  Future<void> createCategory({
    required String name,
    String? description,
    String icon = 'category',
    String color = '#45B7D1',
    String? familyId,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      final category = await _repository.createCategory(
        name: name,
        description: description,
        icon: icon,
        color: color,
        familyId: familyId,
      );

      await loadCategories();
      _selectedCategory = category;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create category: $e');
      _setLoading(false);
    }
  }

  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    String? icon,
    String? color,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.updateCategory(
        categoryId: categoryId,
        name: name,
        description: description,
        icon: icon,
        color: color,
      );

      await loadCategories();
      if (_selectedCategory?.id == categoryId) {
        await loadCategory(categoryId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update category: $e');
      _setLoading(false);
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.deleteCategory(categoryId);
      
      await loadCategories();
      if (_selectedCategory?.id == categoryId) {
        _selectedCategory = null;
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete category: $e');
      _setLoading(false);
    }
  }

  Future<void> archiveCategory(String categoryId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.archiveCategory(categoryId);
      
      await loadCategories();
      if (_selectedCategory?.id == categoryId) {
        await loadCategory(categoryId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to archive category: $e');
      _setLoading(false);
    }
  }

  Future<void> restoreCategory(String categoryId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.restoreCategory(categoryId);
      
      await loadCategories();
      if (_selectedCategory?.id == categoryId) {
        await loadCategory(categoryId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to restore category: $e');
      _setLoading(false);
    }
  }

  // ============ Merge Operations ============
  
  Future<void> mergeCategories({
    required String sourceCategoryId,
    required String targetCategoryId,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.mergeCategories(
        sourceCategoryId: sourceCategoryId,
        targetCategoryId: targetCategoryId,
      );

      await loadCategories();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to merge categories: $e');
      _setLoading(false);
    }
  }

  // ============ Search and Filter ============
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void resetFilter() {
    _filter = 'all';
    notifyListeners();
  }

  // ============ Selection Operations ============
  
  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCategory = null;
    notifyListeners();
  }

  // ============ Utility Methods ============
  
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  bool hasCategories() => _categories.isNotEmpty;
  
  bool hasActiveCategories() => activeCategories.isNotEmpty;
  
  bool hasArchivedCategories() => archivedCategories.isNotEmpty;

  int getCategoryCount() => _categories.length;
  
  int getActiveCategoryCount() => activeCategories.length;
  
  int getArchivedCategoryCount() => archivedCategories.length;

  bool isCategorySelected(String id) => _selectedCategory?.id == id;

  // ============ Validation Methods ============
  
  String? validateCategoryName(String? name) {
    final result = CategoryValidator.validateName(name);
    return result.isValid ? null : result.message;
  }

  // ============ Private Helpers ============
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
