import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/family_repository.dart';
import '../repositories/member_repository.dart';
import '../enums/family_role.dart';
import 'family_state.dart';

/// Notifier for family state management
class FamilyNotifier extends StateNotifier<FamilyState> {
  final FamilyRepository _familyRepository;
  final MemberRepository _memberRepository;

  FamilyNotifier(this._familyRepository, this._memberRepository)
      : super(FamilyState.initial()) {
    initialize();
  }

  /// Initialize the family state
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Load user's families
      final families = await _familyRepository.getUserFamilies();
      state = state.copyWith(families: families);
      
      // Load current family
      final currentFamilyId = await _familyRepository.getCurrentFamilyId();
      if (currentFamilyId != null) {
        await loadFamily(currentFamilyId);
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = FamilyState.error('Failed to initialize: $e');
    }
  }

  /// Load a specific family
  Future<void> loadFamily(String familyId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final family = await _familyRepository.getFamily(familyId);
      final members = await _memberRepository.getFamilyMembers(familyId);
      final invitations = await _familyRepository.getFamilyInvitations(familyId);
      final statistics = await _familyRepository.getFamilyStatistics(familyId);
      
      // Determine user's role
      final currentUserId = await _familyRepository.getCurrentUserId();
      final currentMember = members.firstWhereOrNull((m) => m.userId == currentUserId);
      
      state = state.copyWith(
        currentFamily: family,
        members: members,
        invitations: invitations,
        statistics: statistics,
        isLoading: false,
        isOwner: currentMember?.role == FamilyRole.owner,
        isModerator: currentMember?.role == FamilyRole.moderator,
        userRole: currentMember?.role,
      );
    } catch (e) {
      state = FamilyState.error('Failed to load family: $e');
    }
  }

  /// Create a new family
  Future<void> createFamily(String name, {String? description, String? currency}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final family = await _familyRepository.createFamily(
        name: name,
        description: description,
        currency: currency,
      );
      
      // Refresh families list
      final families = await _familyRepository.getUserFamilies();
      state = state.copyWith(families: families);
      
      // Load the new family
      await loadFamily(family.id);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = FamilyState.error('Failed to create family: $e');
    }
  }

  /// Switch to a different family
  Future<void> switchFamily(String familyId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await _familyRepository.setCurrentFamilyId(familyId);
      await loadFamily(familyId);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = FamilyState.error('Failed to switch family: $e');
    }
  }

  /// Update family settings
  Future<void> updateFamily({
    String? name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      await _familyRepository.updateFamily(
        currentFamily.id,
        name: name,
        description: description,
        currency: currency,
        timezone: timezone,
        country: country,
        language: language,
      );
      
      await loadFamily(currentFamily.id);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = FamilyState.error('Failed to update family: $e');
    }
  }

  /// Leave the current family
  Future<void> leaveFamily() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      // Check if user is the only owner
      if (state.isOnlyOwner) {
        throw Exception('Cannot leave: You are the only owner. Transfer ownership first.');
      }
      
      await _familyRepository.leaveFamily(currentFamily.id);
      
      // Switch to another family or clear state
      final families = await _familyRepository.getUserFamilies();
      state = state.copyWith(families: families);
      
      if (families.isNotEmpty) {
        await switchFamily(families.first.id);
      } else {
        state = state.copyWith(
          currentFamily: null,
          members: [],
          invitations: [],
          statistics: null,
          isLoading: false,
          isOwner: false,
          isModerator: false,
          userRole: null,
        );
        await _familyRepository.setCurrentFamilyId(null);
      }
    } catch (e) {
      state = FamilyState.error('Failed to leave family: $e');
    }
  }

  /// Delete the current family
  Future<void> deleteFamily() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      if (!state.isOwner) {
        throw Exception('Only the owner can delete the family');
      }
      
      await _familyRepository.deleteFamily(currentFamily.id);
      
      // Switch to another family or clear state
      final families = await _familyRepository.getUserFamilies();
      state = state.copyWith(families: families);
      
      if (families.isNotEmpty) {
        await switchFamily(families.first.id);
      } else {
        state = state.copyWith(
          currentFamily: null,
          members: [],
          invitations: [],
          statistics: null,
          isLoading: false,
          isOwner: false,
          isModerator: false,
          userRole: null,
        );
        await _familyRepository.setCurrentFamilyId(null);
      }
    } catch (e) {
      state = FamilyState.error('Failed to delete family: $e');
    }
  }

  /// Invite a member
  Future<void> inviteMember(String email, {String? name, FamilyRole role = FamilyRole.member}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      await _familyRepository.inviteMember(
        familyId: currentFamily.id,
        email: email,
        name: name,
        role: role,
      );
      
      // Refresh invitations
      final invitations = await _familyRepository.getFamilyInvitations(currentFamily.id);
      state = state.copyWith(
        invitations: invitations,
        isLoading: false,
      );
    } catch (e) {
      state = FamilyState.error('Failed to invite member: $e');
    }
  }

  /// Remove a member
  Future<void> removeMember(String memberId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      // Check if trying to remove owner
      final member = state.members.firstWhereOrNull((m) => m.id == memberId);
      if (member?.role == FamilyRole.owner) {
        throw Exception('Cannot remove the family owner');
      }
      
      await _familyRepository.removeMember(currentFamily.id, memberId);
      
      // Refresh members
      final members = await _memberRepository.getFamilyMembers(currentFamily.id);
      state = state.copyWith(
        members: members,
        isLoading: false,
      );
    } catch (e) {
      state = FamilyState.error('Failed to remove member: $e');
    }
  }

  /// Change member role
  Future<void> changeRole(String memberId, FamilyRole newRole) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      // Check if trying to change owner
      final member = state.members.firstWhereOrNull((m) => m.id == memberId);
      if (member?.role == FamilyRole.owner) {
        throw Exception('Cannot change the owner\'s role');
      }
      
      await _familyRepository.changeRole(currentFamily.id, memberId, newRole);
      
      // Refresh members
      final members = await _memberRepository.getFamilyMembers(currentFamily.id);
      state = state.copyWith(
        members: members,
        isLoading: false,
      );
    } catch (e) {
      state = FamilyState.error('Failed to change role: $e');
    }
  }

  /// Transfer ownership
  Future<void> transferOwnership(String newOwnerId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final currentFamily = state.currentFamily;
      if (currentFamily == null) {
        throw Exception('No family selected');
      }
      
      // Check if new owner exists
      final newOwner = state.members.firstWhereOrNull((m) => m.id == newOwnerId);
      if (newOwner == null) {
        throw Exception('Member not found');
      }
      if (newOwner.role == FamilyRole.owner) {
        throw Exception('Cannot transfer ownership to yourself');
      }
      
      await _familyRepository.transferOwnership(currentFamily.id, newOwnerId);
      
      // Refresh family data
      await loadFamily(currentFamily.id);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = FamilyState.error('Failed to transfer ownership: $e');
    }
  }

  /// Refresh the current state
  Future<void> refresh() async {
    final currentFamily = state.currentFamily;
    if (currentFamily != null) {
      await loadFamily(currentFamily.id);
    } else {
      await initialize();
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = FamilyState.initial();
  }
}
