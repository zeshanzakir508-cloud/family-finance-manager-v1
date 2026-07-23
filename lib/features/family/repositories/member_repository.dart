import '../enums/family_role.dart';
import '../enums/member_status.dart';
import '../services/member_service.dart';

/// Repository for member data operations
class MemberRepository {
  final MemberService _service;

  MemberRepository(this._service);

  /// Get all members of a family
  Future<List<MemberModel>> getFamilyMembers(String familyId) async {
    return await _service.getFamilyMembers(familyId);
  }

  /// Get a member by ID
  Future<MemberModel> getMember(String memberId) async {
    return await _service.getMember(memberId);
  }

  /// Get a member by user ID
  Future<MemberModel?> getMemberByUserId(String userId) async {
    return await _service.getMemberByUserId(userId);
  }

  /// Update a member's profile
  Future<void> updateMember(String memberId, {String? name, String? avatar}) async {
    await _service.updateMember(memberId, name: name, avatar: avatar);
  }

  /// Change a member's role
  Future<void> changeRole(String familyId, String memberId, FamilyRole newRole) async {
    await _service.changeRole(familyId, memberId, newRole);
  }

  /// Suspend a member
  Future<void> suspendMember(String familyId, String memberId) async {
    await _service.suspendMember(familyId, memberId);
  }

  /// Restore a suspended member
  Future<void> restoreMember(String familyId, String memberId) async {
    await _service.restoreMember(familyId, memberId);
  }

  /// Remove a member from a family
  Future<void> removeMember(String familyId, String memberId) async {
    await _service.removeMember(familyId, memberId);
  }

  /// Transfer ownership to another member
  Future<void> transferOwnership(String familyId, String newOwnerId) async {
    await _service.transferOwnership(familyId, newOwnerId);
  }

  /// Get members by role
  Future<List<MemberModel>> getMembersByRole(String familyId, FamilyRole role) async {
    return await _service.getMembersByRole(familyId, role);
  }

  /// Get members by status
  Future<List<MemberModel>> getMembersByStatus(String familyId, MemberStatus status) async {
    return await _service.getMembersByStatus(familyId, status);
  }

  /// Get active members
  Future<List<MemberModel>> getActiveMembers(String familyId) async {
    return await _service.getActiveMembers(familyId);
  }

  /// Check if a user is a member of a family
  Future<bool> isMember(String familyId) async {
    return await _service.isMember(familyId);
  }

  /// Check if a user is a member by email
  Future<bool> isMemberByEmail(String familyId, String email) async {
    return await _service.isMemberByEmail(familyId, email);
  }

  /// Check if a user is the owner
  Future<bool> isOwner(String familyId) async {
    return await _service.isOwner(familyId);
  }

  /// Check if a user is the only owner
  Future<bool> isOnlyOwner(String familyId) async {
    return await _service.isOnlyOwner(familyId);
  }

  /// Check if a user is a moderator
  Future<bool> isModerator(String familyId) async {
    return await _service.isModerator(familyId);
  }

  /// Get the current user's role in a family
  Future<FamilyRole?> getUserRole(String familyId) async {
    return await _service.getUserRole(familyId);
  }

  /// Get the owner of a family
  Future<MemberModel> getFamilyOwner(String familyId) async {
    return await _service.getFamilyOwner(familyId);
  }

  /// Get member count by status
  Future<Map<MemberStatus, int>> getMemberCountByStatus(String familyId) async {
    return await _service.getMemberCountByStatus(familyId);
  }

  /// Get member count by role
  Future<Map<FamilyRole, int>> getMemberCountByRole(String familyId) async {
    return await _service.getMemberCountByRole(familyId);
  }

  /// Get total member count
  Future<int> getMemberCount(String familyId) async {
    return await _service.getMemberCount(familyId);
  }

  /// Get active member count
  Future<int> getActiveMemberCount(String familyId) async {
    return await _service.getActiveMemberCount(familyId);
  }

  /// Check if the family is full
  Future<bool> isFamilyFull(String familyId) async {
    return await _service.isFamilyFull(familyId);
  }

  /// Get member statistics
  Future<Map<String, dynamic>> getMemberStatistics(String familyId) async {
    final total = await getMemberCount(familyId);
    final active = await getActiveMemberCount(familyId);
    final byStatus = await getMemberCountByStatus(familyId);
    final byRole = await getMemberCountByRole(familyId);

    return {
      'total': total,
      'active': active,
      'pending': byStatus[MemberStatus.pending] ?? 0,
      'suspended': byStatus[MemberStatus.suspended] ?? 0,
      'blocked': byStatus[MemberStatus.blocked] ?? 0,
      'removed': byStatus[MemberStatus.removed] ?? 0,
      'left': byStatus[MemberStatus.left] ?? 0,
      'owner': byRole[FamilyRole.owner] ?? 0,
      'moderator': byRole[FamilyRole.moderator] ?? 0,
      'member': byRole[FamilyRole.member] ?? 0,
      'viewer': byRole[FamilyRole.viewer] ?? 0,
    };
  }

  /// Search members by name or email
  Future<List<MemberModel>> searchMembers(String familyId, String query) async {
    return await _service.searchMembers(familyId, query);
  }

  /// Get member activity
  Future<List<Map<String, dynamic>>> getMemberActivity(String familyId, String memberId) async {
    return await _service.getMemberActivity(familyId, memberId);
  }

  /// Get member permissions
  Future<List<String>> getMemberPermissions(String familyId, String memberId) async {
    return await _service.getMemberPermissions(familyId, memberId);
  }

  /// Check if a member has a specific permission
  Future<bool> hasPermission(String familyId, String memberId, String permission) async {
    return await _service.hasPermission(familyId, memberId, permission);
  }
}
