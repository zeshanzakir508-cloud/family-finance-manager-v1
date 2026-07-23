import 'package:flutter/material.dart';
import '../enums/family_role.dart';
import '../enums/member_status.dart';
import '../repositories/member_repository.dart';
import '../validators/member_validator.dart';

/// Business logic controller for member management
class MemberController extends ChangeNotifier {
  final MemberRepository _repository;

  /// List of family members
  List<MemberModel> _members = [];
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;

  MemberController(this._repository);

  // ============ Getters ============
  
  List<MemberModel> get members => _members;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<MemberModel> get activeMembers => 
      _members.where((m) => m.status == MemberStatus.active).toList();
  
  List<MemberModel> get pendingMembers => 
      _members.where((m) => m.status == MemberStatus.pending).toList();
  
  List<MemberModel> get suspendedMembers => 
      _members.where((m) => m.status == MemberStatus.suspended).toList();
  
  MemberModel? get owner => 
      _members.firstWhere((m) => m.role == FamilyRole.owner, orElse: () => throw Exception('No owner found'));

  // ============ Member Loading ============
  
  Future<void> loadMembers(String familyId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _members = await _repository.getFamilyMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load members: $e');
      _setLoading(false);
    }
  }

  Future<void> refresh(String familyId) async {
    await loadMembers(familyId);
  }

  // ============ Member Management ============
  
  Future<void> inviteMember({
    required String familyId,
    required String email,
    String? name,
    FamilyRole role = FamilyRole.member,
  }) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Validate email
      final validation = MemberValidator.validateEmail(email);
      if (!validation.isValid) {
        _setError(validation.message);
        _setLoading(false);
        return;
      }
      
      // Check if already a member
      final isMember = await _repository.isMemberByEmail(familyId, email);
      if (isMember) {
        _setError('This user is already a member of the family');
        _setLoading(false);
        return;
      }
      
      await _repository.inviteMember(
        familyId: familyId,
        email: email,
        name: name,
        role: role,
      );
      
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to invite member: $e');
      _setLoading(false);
    }
  }

  Future<void> removeMember(String familyId, String memberId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Check if trying to remove owner
      final member = _members.firstWhere((m) => m.id == memberId);
      if (member.role == FamilyRole.owner) {
        _setError('Cannot remove the family owner');
        _setLoading(false);
        return;
      }
      
      await _repository.removeMember(familyId, memberId);
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to remove member: $e');
      _setLoading(false);
    }
  }

  Future<void> changeRole(String familyId, String memberId, FamilyRole newRole) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Check if trying to change owner
      final member = _members.firstWhere((m) => m.id == memberId);
      if (member.role == FamilyRole.owner) {
        _setError('Cannot change the owner\'s role');
        _setLoading(false);
        return;
      }
      
      await _repository.changeRole(familyId, memberId, newRole);
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to change role: $e');
      _setLoading(false);
    }
  }

  Future<void> suspendMember(String familyId, String memberId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      final member = _members.firstWhere((m) => m.id == memberId);
      if (member.role == FamilyRole.owner) {
        _setError('Cannot suspend the family owner');
        _setLoading(false);
        return;
      }
      
      await _repository.suspendMember(familyId, memberId);
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to suspend member: $e');
      _setLoading(false);
    }
  }

  Future<void> restoreMember(String familyId, String memberId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      await _repository.restoreMember(familyId, memberId);
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to restore member: $e');
      _setLoading(false);
    }
  }

  Future<void> transferOwnership(String familyId, String newOwnerId) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      // Check if new owner exists
      final newOwner = _members.firstWhere((m) => m.id == newOwnerId);
      if (newOwner.id == owner.id) {
        _setError('Cannot transfer ownership to yourself');
        _setLoading(false);
        return;
      }
      
      await _repository.transferOwnership(familyId, newOwnerId);
      await loadMembers(familyId);
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to transfer ownership: $e');
      _setLoading(false);
    }
  }

  // ============ Utility Methods ============
  
  MemberModel? getMember(String memberId) {
    try {
      return _members.firstWhere((m) => m.id == memberId);
    } catch (e) {
      return null;
    }
  }

  bool isOwner(String memberId) {
    final member = getMember(memberId);
    return member?.role == FamilyRole.owner;
  }

  bool isAdmin(String memberId) {
    final member = getMember(memberId);
    return member?.role == FamilyRole.owner || member?.role == FamilyRole.moderator;
  }

  bool hasPermission(String memberId, String permission) {
    final member = getMember(memberId);
    if (member == null) return false;
    
    // Owner has all permissions
    if (member.role == FamilyRole.owner) return true;
    
    // Check based on role
    switch (member.role) {
      case FamilyRole.moderator:
        return true; // Moderators have most permissions
      case FamilyRole.member:
        return permission.startsWith('transactions:') || permission == 'reports:view';
      case FamilyRole.viewer:
        return permission == 'reports:view';
      default:
        return false;
    }
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
