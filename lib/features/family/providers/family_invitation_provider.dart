import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/invite_status.dart';

/// Provider for filtering invitations by status
final invitationsByStatusProvider = Provider.family<List<FamilyInvitationModel>, InviteStatus>((ref, status) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.where((i) => i.status == status).toList();
});

/// Provider for active invitations (pending and not expired)
final activeInvitationsProvider = Provider<List<FamilyInvitationModel>>((ref) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.where((i) => i.isActive).toList();
});

/// Provider for expired invitations
final expiredInvitationsProvider = Provider<List<FamilyInvitationModel>>((ref) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.where((i) => i.isExpired).toList();
});

/// Provider for getting a specific invitation by code
final invitationByCodeProvider = Provider.family<FamilyInvitationModel?, String>((ref, code) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.firstWhereOrNull((i) => i.code == code);
});

/// Provider for getting a specific invitation by ID
final invitationByIdProvider = Provider.family<FamilyInvitationModel?, String>((ref, id) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.firstWhereOrNull((i) => i.id == id);
});

/// Provider for checking if an invitation exists by email
final invitationExistsByEmailProvider = Provider.family<bool, String>((ref, email) {
  final invitations = ref.watch(familyInvitationsProvider);
  return invitations.any((i) => i.email == email && i.isActive);
});

/// Provider for checking if an invitation is valid
final isValidInvitationProvider = Provider.family<bool, String>((ref, code) {
  final invitation = ref.watch(invitationByCodeProvider(code));
  return invitation != null && invitation.isActive;
});

/// Provider for pending invitation count
final pendingInvitationCountProvider = Provider<int>((ref) {
  final invitations = ref.watch(activeInvitationsProvider);
  return invitations.length;
});

/// Provider for invitation statistics
final invitationStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final pending = ref.watch(pendingInvitationCountProvider);
  final expired = ref.watch(expiredInvitationsProvider).length;
  final accepted = ref.watch(invitationsByStatusProvider(InviteStatus.accepted)).length;
  final rejected = ref.watch(invitationsByStatusProvider(InviteStatus.rejected)).length;
  final cancelled = ref.watch(invitationsByStatusProvider(InviteStatus.cancelled)).length;
  final total = ref.watch(familyInvitationsProvider).length;

  return {
    'total': total,
    'pending': pending,
    'accepted': accepted,
    'rejected': rejected,
    'expired': expired,
    'cancelled': cancelled,
  };
});

/// Provider for recent invitations (last 7 days)
final recentInvitationsProvider = Provider<List<FamilyInvitationModel>>((ref) {
  final invitations = ref.watch(familyInvitationsProvider);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  return invitations.where((i) => i.createdAt.isAfter(sevenDaysAgo)).toList();
});

/// Provider for invitation actions
final invitationActionsProvider = Provider<InvitationActions>((ref) {
  final notifier = ref.watch(familyNotifierProvider.notifier);
  return InvitationActions(notifier);
});

/// Class containing invitation actions
class InvitationActions {
  final FamilyNotifier _notifier;

  InvitationActions(this._notifier);

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
}
