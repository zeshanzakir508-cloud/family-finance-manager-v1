import 'package:flutter/material.dart';
import '../repositories/family_repository.dart';

/// Business logic controller for family settings
class FamilySettingsController extends ChangeNotifier {
  final FamilyRepository _repository;

  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;

  FamilySettingsController(this._repository);

  // ============ Getters ============
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ============ Settings Management ============
  
  Future<void> updateFamilyName(String familyId, String name) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      if (name.trim().length < 2) {
        _setError('Family name must be at least 2 characters');
        _setLoading(false);
        return;
      }
      
      await _repository.updateFamily(familyId, name: name.trim());
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update family name: $e');
      _setLoading(false);
    }
  }

  Future<void> updateFamilyCurrency(String familyId, String currency) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.updateFamily(familyId, currency: currency);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update currency: $e');
      _setLoading(false);
    }
  }

  Future<void> updateFamilyDescription(String familyId, String description) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.updateFamily(familyId, description: description);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update description: $e');
      _setLoading(false);
    }
  }

  Future<void> updateFamilySettings({
    required String familyId,
    String? name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  }) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.updateFamily(
        familyId,
        name: name,
        description: description,
        currency: currency,
        timezone: timezone,
        country: country,
        language: language,
      );
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update settings: $e');
      _setLoading(false);
    }
  }

  Future<void> archiveFamily(String familyId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.archiveFamily(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to archive family: $e');
      _setLoading(false);
    }
  }

  Future<void> unarchiveFamily(String familyId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.unarchiveFamily(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to unarchive family: $e');
      _setLoading(false);
    }
  }

  // ============ Utility Methods ============
  
  bool isCurrencySupported(String currency) {
    final supported = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR'];
    return supported.contains(currency);
  }

  List<String> getSupportedCurrencies() {
    return ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR'];
  }

  List<String> getSupportedLanguages() {
    return ['en', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'zh', 'ar'];
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
