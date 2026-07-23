import '../enums/family_role.dart';
import '../enums/member_status.dart';

/// Interface for member service operations
abstract class MemberService {
  /// Get all members of a family
  Future<List<MemberModel>> getFamilyMembers(String familyId);

  /// Get a member by ID
  Future<MemberModel> getMember(String memberId);

  /// Get a member by user ID
  Future<MemberModel?> getMemberByUserId(String userId);

  /// Update a member's profile
  Future<void> updateMember(String memberId, {String? name, String? avatar});

  /// Change a member's role
  Future<void> changeRole(String familyId, String memberId, FamilyRole newRole);

  /// Suspend a member
  Future<void> suspendMember(String familyId, String memberId);

  /// Restore a suspended member
  Future<void> restoreMember(String familyId, String memberId);

  /// Remove a member from a family
  Future<void> removeMember(String familyId, String memberId);

  /// Transfer ownership to another member
  Future<void> transferOwnership(String familyId, String newOwnerId);

  /// Get members by role
  Future<List<MemberModel>> getMembersByRole(String familyId, FamilyRole role);

  /// Get members by status
  Future<List<MemberModel>> getMembersByStatus(String familyId, MemberStatus status);

  /// Get active members
  Future<List<MemberModel>> getActiveMembers(String familyId);

  /// Check if a user is a member of a family
  Future<bool> isMember(String familyId);

  /// Check if a user is a member by email
  Future<bool> isMemberByEmail(String familyId, String email);

  /// Check if a user is the owner
  Future<bool> isOwner(String familyId);

  /// Check if a user is the only owner
  Future<bool> isOnlyOwner(String familyId);

  /// Check if a user is a moderator
  Future<bool> isModerator(String familyId);

  /// Get the current user's role in a family
  Future<FamilyRole?> getUserRole(String familyId);

  /// Get the owner of a family
  Future<MemberModel> getFamilyOwner(String familyId);

  /// Get member count by status
  Future<Map<MemberStatus, int>> getMemberCountByStatus(String familyId);

  /// Get member count by role
  Future<Map<FamilyRole, int>> getMemberCountByRole(String familyId);

  /// Get total member count
  Future<int> getMemberCount(String familyId);

  /// Get active member count
  Future<int> getActiveMemberCount(String familyId);

  /// Check if the family is full
  Future<bool> isFamilyFull(String familyId);

  /// Search members by name or email
  Future<List<MemberModel>> searchMembers(String familyId, String query);

  /// Get member activity
  Future<List<Map<String, dynamic>>> getMemberActivity(String familyId, String memberId);

  /// Get member permissions
  Future<List<String>> getMemberPermissions(String familyId, String memberId);

  /// Check if a member has a specific permission
  Future<bool> hasPermission(String familyId, String memberId, String permission);
}
