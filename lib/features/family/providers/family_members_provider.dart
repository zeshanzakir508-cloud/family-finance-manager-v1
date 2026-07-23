import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/family_role.dart';
import '../enums/member_status.dart';

/// Provider for filtering members by role
final familyMembersByRoleProvider = Provider.family<List<MemberModel>, FamilyRole>((ref, role) {
  final members = ref.watch(familyMembersProvider);
  return members.where((m) => m.role == role).toList();
});

/// Provider for filtering members by status
final familyMembersByStatusProvider = Provider.family<List<MemberModel>, MemberStatus>((ref, status) {
  final members = ref.watch(familyMembersProvider);
  return members.where((m) => m.status == status).toList();
});

/// Provider for getting a specific member by ID
final familyMemberByIdProvider = Provider.family<MemberModel?, String>((ref, memberId) {
  final members = ref.watch(familyMembersProvider);
  return members.firstWhereOrNull((m) => m.id == memberId);
});

/// Provider for getting a member by user ID
final familyMemberByUserIdProvider = Provider.family<MemberModel?, String>((ref, userId) {
  final members = ref.watch(familyMembersProvider);
  return members.firstWhereOrNull((m) => m.userId == userId);
});

/// Provider for checking if a member is an admin
final isMemberAdminProvider = Provider.family<bool, String>((ref, memberId) {
  final members = ref.watch(familyMembersProvider);
  final member = members.firstWhereOrNull((m) => m.id == memberId);
  return member != null && (member.role == FamilyRole.owner || member.role == FamilyRole.moderator);
});

/// Provider for checking if a member is the owner
final isMemberOwnerProvider = Provider.family<bool, String>((ref, memberId) {
  final members = ref.watch(familyMembersProvider);
  final member = members.firstWhereOrNull((m) => m.id == memberId);
  return member?.role == FamilyRole.owner;
});

/// Provider for getting members count by role
final membersCountByRoleProvider = Provider.family<int, FamilyRole>((ref, role) {
  final members = ref.watch(familyMembersByRoleProvider(role));
  return members.length;
});

/// Provider for active members count
final activeMembersCountProvider = Provider<int>((ref) {
  final members = ref.watch(activeMembersProvider);
  return members.length;
});

/// Provider for pending members count
final pendingMembersCountProvider = Provider<int>((ref) {
  final members = ref.watch(familyMembersByStatusProvider(MemberStatus.pending));
  return members.length;
});

/// Provider for suspended members count
final suspendedMembersCountProvider = Provider<int>((ref) {
  final members = ref.watch(familyMembersByStatusProvider(MemberStatus.suspended));
  return members.length;
});

/// Provider for member statistics
final memberStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final total = ref.watch(familyMemberCountProvider);
  final active = ref.watch(activeMembersCountProvider);
  final pending = ref.watch(pendingMembersCountProvider);
  final suspended = ref.watch(suspendedMembersCountProvider);
  final ownerCount = ref.watch(membersCountByRoleProvider(FamilyRole.owner));
  final moderatorCount = ref.watch(membersCountByRoleProvider(FamilyRole.moderator));
  final memberCount = ref.watch(membersCountByRoleProvider(FamilyRole.member));
  final viewerCount = ref.watch(membersCountByRoleProvider(FamilyRole.viewer));

  return {
    'total': total,
    'active': active,
    'pending': pending,
    'suspended': suspended,
    'owner': ownerCount,
    'moderator': moderatorCount,
    'member': memberCount,
    'viewer': viewerCount,
  };
});
