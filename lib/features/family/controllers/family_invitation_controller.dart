import 'package:flutter/material.dart';
import '../models/family_invitation_model.dart';
import '../enums/invite_status.dart';
import '../repositories/family_repository.dart';
import '../validators/invite_validator.dart';

/// Business logic controller for invitation management
class FamilyInvitationController extends ChangeNotifier {
  final FamilyRepository _repository;

  /// List of invitations
  List<FamilyInvitationModel> _invitations = [];
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;

  FamilyInvitationController(this._repository);

  // ============ Getters ============
  
  List<FamilyInvitationModel> get invitations => _invitations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<FamilyInvitationModel> get pendingInvitations => 
      _invitations.where((i) => i.status == InviteStatus.pending && !i.isExpired).toList();
  
  List<FamilyInvitationModel> get expiredInvitations => 
      _invitations.where((i) => i.isExpired).toList();

  // ============ Invitation Loading ============
  
  Future<void> loadInvitations(String familyId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _invitations = await _repository.getFamilyInvitations(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load invitations: $e');
      _setLoading(false);
    }
  }

  Future<void> refresh(String familyId) async {
    await loadInvitations(familyId);
  }

  // ============ Invitation Management ============
  
  Future<String> createInvitation({
    required String familyId,
    required String email,
    String? name,
    String role = 'member',
  }) async {
    if (_isLoading) return '';
    
    try {
      _setLoading(true);
      _clearError();
      
      // Validate email
      final validation = InviteValidator.validateEmail(email);
      if (!validation.isValid) {
        _setError(validation.message);
        _setLoading(false);
        return '';
      }
      
      // Check for existing pending invitation
      final existing = _invitations.where((i) => 
        i.email == email && 
        i.status == InviteStatus.pending && 
        !i.isExpired
      ).toList();
      
      if (existing.isNotEmpty) {
        _setError('An invitation has already been sent to this email');
        _setLoading(false);
        return '';
      }
      
      final invite = await _repository.createInvitation(
        familyId: familyId,
        email: email,
        name: name,
        role: role,
      );
      
      await loadInvitations(familyId);
      
      _setLoading(false);
      return invite.code;
    } catch (e) {
      _setError('Failed to create invitation: $e');
      _setLoading(false);
      return '';
    }
  }

  Future<bool> acceptInvitation(String code) async {
    if (_isLoading) return false;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Find invitation
      final invite = _invitations.firstWhere(
        (i) => i.code == code,
        orElse: () => throw Exception('Invitation not found'),
      );
      
      // Check if valid
      if (!invite.isActive) {
        _setError('Invitation is no longer valid');
        _setLoading(false);
        return false;
      }
      
      final success = await _repository.acceptInvitation(code);
      
      if (success) {
        await loadInvitations(invite.familyId);
      }
      
      _setLoading(false);
      return success;
    } catch (e) {
      _setError('Failed to accept invitation: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> rejectInvitation(String code) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      final invite = _invitations.firstWhere(
        (i) => i.code == code,
        orElse: () => throw Exception('Invitation not found'),
      );
      
      await _repository.rejectInvitation(code);
      await loadInvitations(invite.familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to reject invitation: $e');
      _setLoading(false);
    }
  }

  Future<void> cancelInvitation(String invitationId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      final invite = _invitations.firstWhere(
        (i) => i.id == invitationId,
        orElse: () => throw Exception('Invitation not found'),
      );
      
      await _repository.cancelInvitation(invitationId);
      await loadInvitations(invite.familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to cancel invitation: $e');
      _setLoading(false);
    }
  }

  Future<void> resendInvitation(String invitationId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      final invite = _invitations.firstWhere(
        (i) => i.id == invitationId,
        orElse: () => throw Exception('Invitation not found'),
      );
      
      // Check resend limit
      if (invite.resendCount >= 3) {
        _setError('Maximum resend attempts reached');
        _setLoading(false);
        return;
      }
      
      await _repository.resendInvitation(invitationId);
      await loadInvitations(invite.familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to resend invitation: $e');
      _setLoading(false);
    }
  }

  // ============ Utility Methods ============
  
  FamilyInvitationModel? getInvitation(String code) {
    try {
      return _invitations.firstWhere((i) => i.code == code);
    } catch (e) {
      return null;
    }
  }

  bool isValidInvitation(String code) {
    final invite = getInvitation(code);
    return invite != null && invite.isActive;
  }

  bool hasPendingInvitation(String email) {
    return _invitations.any((i) => 
      i.email == email && 
      i.status == InviteStatus.pending && 
      !i.isExpired
    );
  }

  int getPendingCount() {
    return pendingInvitations.length;
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
