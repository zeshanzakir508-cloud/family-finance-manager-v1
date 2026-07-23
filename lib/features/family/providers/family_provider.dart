import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/family_repository.dart';
import '../repositories/member_repository.dart';
import 'family_notifier.dart';
import 'family_state.dart';

/// Provider for FamilyRepository
final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  throw UnimplementedError('FamilyRepository must be provided');
});

/// Provider for MemberRepository
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  throw UnimplementedError('MemberRepository must be provided');
});

/// Provider for FamilyNotifier
final familyNotifierProvider = StateNotifierProvider<FamilyNotifier, FamilyState>((ref) {
  final familyRepo = ref.watch(familyRepositoryProvider);
  final memberRepo = ref.watch(memberRepositoryProvider);
  return FamilyNotifier(familyRepo, memberRepo);
});

/// Provider for family state (read-only)
final familyStateProvider = Provider<FamilyState>((ref) {
  return ref.watch(familyNotifierProvider);
});

/// Provider for current family
final currentFamilyProvider = Provider<FamilyModel?>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.currentFamily;
});

/// Provider for family members
final familyMembersProvider = Provider<List<MemberModel>>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.members;
});

/// Provider for active members
final activeMembersProvider = Provider<List<MemberModel>>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.activeMembers;
});

/// Provider for family invitations
final familyInvitationsProvider = Provider<List<FamilyInvitationModel>>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.invitations;
});

/// Provider for pending invitations
final pendingInvitationsProvider = Provider<List<FamilyInvitationModel>>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.pendingInvitations;
});

/// Provider for family statistics
final familyStatisticsProvider = Provider<FamilyStatisticsModel?>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.statistics;
});

/// Provider for family member count
final familyMemberCountProvider = Provider<int>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.memberCount;
});

/// Provider for family owner
final familyOwnerProvider = Provider<MemberModel?>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.owner;
});

/// Provider for checking if user is owner
final isFamilyOwnerProvider = Provider<bool>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.isOwner;
});

/// Provider for checking if user is moderator
final isFamilyModeratorProvider = Provider<bool>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.isModerator;
});

/// Provider for checking if user can manage family
final canManageFamilyProvider = Provider<bool>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.canManageFamily;
});

/// Provider for checking if family is full
final isFamilyFullProvider = Provider<bool>((ref) {
  final state = ref.watch(familyStateProvider);
  return state.isFamilyFull;
});

/// Provider for family actions
final familyActionsProvider = Provider<FamilyActions>((ref) {
  final notifier = ref.watch(familyNotifierProvider.notifier);
  return FamilyActions(notifier);
});

/// Provider for checking if user has a specific permission
final familyPermissionProvider = Provider.family<bool, String>((ref, permission) {
  final state = ref.watch(familyStateProvider);
  final userRole = state.userRole;
  
  if (userRole == null) return false;
  if (userRole == FamilyRole.owner) return true;
  
  // Check permission based on role
  switch (userRole) {
    case FamilyRole.moderator:
      // Moderators have most permissions except owner-only ones
      return !['family:delete', 'family:transfer_ownership'].contains(permission);
    case FamilyRole.member:
      return permission.startsWith('transactions:') || 
             permission == 'reports:view' ||
             permission == 'activity:view';
    case FamilyRole.viewer:
      return permission == 'reports:view';
    default:
      return false;
  }
});

/// Class containing all family actions
class FamilyActions {
  final FamilyNotifier _notifier;

  FamilyActions(this._notifier);

  /// Create a new family
  Future<void> createFamily(String name, {String? description, String? currency}) =>
      _notifier.createFamily(name, description: description, currency: currency);

  /// Switch to a different family
  Future<void> switchFamily(String familyId) => _notifier.switchFamily(familyId);

  /// Update family settings
  Future<void> updateFamily({
    String? name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  }) => _notifier.updateFamily(
    name: name,
    description: description,
    currency: currency,
    timezone: timezone,
    country: country,
    language: language,
  );

  /// Leave the current family
  Future<void> leaveFamily() => _notifier.leaveFamily();

  /// Delete the current family
  Future<void> deleteFamily() => _notifier.deleteFamily();

  /// Invite a member
  Future<void> inviteMember(String email, {String? name, FamilyRole role = FamilyRole.member}) =>
      _notifier.inviteMember(email, name: name, role: role);

  /// Remove a member
  Future<void> removeMember(String memberId) => _notifier.removeMember(memberId);

  /// Change member role
  Future<void> changeRole(String memberId, FamilyRole newRole) =>
      _notifier.changeRole(memberId, newRole);

  /// Transfer ownership
  Future<void> transferOwnership(String newOwnerId) =>
      _notifier.transferOwnership(newOwnerId);

  /// Refresh state
  Future<void> refresh() => _notifier.refresh();

  /// Clear error
  void clearError() => _notifier.clearError();

  /// Reset state
  void reset() => _notifier.reset();

  /// Load a specific family
  Future<void> loadFamily(String familyId) => _notifier.loadFamily(familyId);
}
