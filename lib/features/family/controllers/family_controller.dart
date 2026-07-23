import 'package:flutter/material.dart';
import '../models/family_invitation_model.dart';
import '../models/family_activity_model.dart';
import '../models/family_statistics_model.dart';
import '../repositories/family_repository.dart';
import '../validators/family_validator.dart';
import '../enums/family_status.dart';
import '../enums/family_role.dart';

/// Business logic controller for family management
class FamilyController extends ChangeNotifier {
  final FamilyRepository _repository;

  /// Current family data
  FamilyModel? _currentFamily;
  
  /// List of user's families
  List<FamilyModel> _families = [];
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Family statistics
  FamilyStatisticsModel? _statistics;

  FamilyController(this._repository) {
    initialize();
  }

  // ============ Getters ============
  
  FamilyModel? get currentFamily => _currentFamily;
  List<FamilyModel> get families => _families;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FamilyStatisticsModel? get statistics => _statistics;
  String? get currentFamilyId => _currentFamily?.id;
  String get currentFamilyName => _currentFamily?.name ?? 'No Family';

  // ============ Initialization ============
  
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      await loadFamilies();
      await loadCurrentFamily();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize family controller: $e');
      _setLoading(false);
    }
  }

  // ============ Family Loading ============
  
  Future<void> loadFamilies() async {
    try {
      _families = await _repository.getUserFamilies();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load families: $e');
      rethrow;
    }
  }

  Future<void> loadCurrentFamily() async {
    try {
      final familyId = await _repository.getCurrentFamilyId();
      if (familyId != null) {
        _currentFamily = await _repository.getFamily(familyId);
        _statistics = await _repository.getFamilyStatistics(familyId);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load current family: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadFamilies();
    await loadCurrentFamily();
  }

  // ============ Family Management ============
  
  Future<void> createFamily(String name, {String? description, String? currency}) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Validate family name
      final validation = FamilyValidator.validateFamilyName(name);
      if (!validation.isValid) {
        _setError(validation.message);
        _setLoading(false);
        return;
      }
      
      // Check family limit
      if (_families.length >= 5) {
        _setError('You have reached the maximum number of families (5)');
        _setLoading(false);
        return;
      }
      
      final family = await _repository.createFamily(
        name: name,
        description: description,
        currency: currency,
      );
      
      await loadFamilies();
      await switchFamily(family.id);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to create family: $e');
      _setLoading(false);
    }
  }

  Future<void> updateFamily(String familyId, {String? name, String? description, String? currency}) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Validate family name
      if (name != null) {
        final validation = FamilyValidator.validateFamilyName(name);
        if (!validation.isValid) {
          _setError(validation.message);
          _setLoading(false);
          return;
        }
      }
      
      await _repository.updateFamily(
        familyId,
        name: name,
        description: description,
        currency: currency,
      );
      
      await loadCurrentFamily();
      await loadFamilies();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update family: $e');
      _setLoading(false);
    }
  }

  Future<void> switchFamily(String familyId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Check if user is a member
      final isMember = await _repository.isMember(familyId);
      if (!isMember) {
        _setError('You are not a member of this family');
        _setLoading(false);
        return;
      }
      
      await _repository.setCurrentFamilyId(familyId);
      await loadCurrentFamily();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to switch family: $e');
      _setLoading(false);
    }
  }

  Future<void> leaveFamily(String familyId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Check if user is the only owner
      final isOnlyOwner = await _repository.isOnlyOwner(familyId);
      if (isOnlyOwner) {
        _setError('Cannot leave: You are the only owner. Transfer ownership first.');
        _setLoading(false);
        return;
      }
      
      await _repository.leaveFamily(familyId);
      
      // If leaving current family, switch to another
      if (_currentFamily?.id == familyId) {
        await loadFamilies();
        if (_families.isNotEmpty) {
          await switchFamily(_families.first.id);
        } else {
          _currentFamily = null;
          _statistics = null;
          await _repository.setCurrentFamilyId(null);
        }
      } else {
        await loadFamilies();
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to leave family: $e');
      _setLoading(false);
    }
  }

  Future<void> deleteFamily(String familyId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Verify user is owner
      final isOwner = await _repository.isOwner(familyId);
      if (!isOwner) {
        _setError('Only the family owner can delete the family');
        _setLoading(false);
        return;
      }
      
      await _repository.deleteFamily(familyId);
      
      // If deleting current family, switch to another
      if (_currentFamily?.id == familyId) {
        await loadFamilies();
        if (_families.isNotEmpty) {
          await switchFamily(_families.first.id);
        } else {
          _currentFamily = null;
          _statistics = null;
          await _repository.setCurrentFamilyId(null);
        }
      } else {
        await loadFamilies();
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete family: $e');
      _setLoading(false);
    }
  }

  // ============ Utility Methods ============
  
  bool isCurrentFamily(String familyId) {
    return _currentFamily?.id == familyId;
  }

  bool isFamilyOwner(String familyId) {
    // This would check if the current user is the owner
    // Implementation depends on user context
    return false;
  }

  Future<bool> hasPermission(String permission) async {
    if (_currentFamily == null) return false;
    return await _repository.hasPermission(_currentFamily!.id, permission);
  }

  String? getFamilyName(String familyId) {
    final family = _families.firstWhere(
      (f) => f.id == familyId,
      orElse: () => throw Exception('Family not found'),
    );
    return family.name;
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
