import '../models/family_invitation_model.dart';
import '../models/family_activity_model.dart';
import '../models/family_statistics_model.dart';
import '../enums/family_role.dart';
import '../enums/family_status.dart';

/// Interface for family service operations
abstract class FamilyService {
  // ============ Family CRUD Operations ============

  /// Get a family by ID
  Future<FamilyModel> getFamily(String familyId);

  /// Get all families for the current user
  Future<List<FamilyModel>> getUserFamilies();

  /// Create a new family
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  });

  /// Update a family
  Future<void> updateFamily(
    String familyId, {
    String? name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  });

  /// Delete a family
  Future<void> deleteFamily(String familyId);

  /// Archive a family
  Future<void> archiveFamily(String familyId);

  /// Unarchive a family
  Future<void> unarchiveFamily(String familyId);

  // ============ Current Family Management ============

  /// Get the current family ID
  Future<String?> getCurrentFamilyId();

  /// Set the current family ID
  Future<void> setCurrentFamilyId(String? familyId);

  // ============ Member Management ============

  /// Invite a member to a family
  Future<FamilyInvitationModel> inviteMember({
    required String familyId,
    required String email,
    String? name,
    FamilyRole role = FamilyRole.member,
  });

  /// Remove a member from a family
  Future<void> removeMember(String familyId, String memberId);

  /// Change a member's role
  Future<void> changeRole(String familyId, String memberId, FamilyRole newRole);

  /// Transfer ownership to another member
  Future<void> transferOwnership(String familyId, String newOwnerId);

  /// Leave a family
  Future<void> leaveFamily(String familyId);

  // ============ Invitation Management ============

  /// Get all invitations for a family
  Future<List<FamilyInvitationModel>> getFamilyInvitations(String familyId);

  /// Create an invitation
  Future<FamilyInvitationModel> createInvitation({
    required String familyId,
    required String email,
    String? name,
    String role = 'member',
  });

  /// Accept an invitation
  Future<bool> acceptInvitation(String code);

  /// Reject an invitation
  Future<void> rejectInvitation(String code);

  /// Cancel an invitation
  Future<void> cancelInvitation(String invitationId);

  /// Resend an invitation
  Future<void> resendInvitation(String invitationId);

  // ============ Activity Management ============

  /// Get family activities
  Future<List<FamilyActivityModel>> getFamilyActivities(
    String familyId, {
    int limit = 50,
    DateTime? after,
  });

  /// Add a family activity
  Future<void> addActivity(FamilyActivityModel activity);

  // ============ Statistics ============

  /// Get family statistics
  Future<FamilyStatisticsModel> getFamilyStatistics(String familyId);

  // ============ Permission Checks ============

  /// Check if a user has a specific permission
  Future<bool> hasPermission(String familyId, String permission);

  /// Check if a user is the owner
  Future<bool> isOwner(String familyId);

  /// Check if a user is the only owner
  Future<bool> isOnlyOwner(String familyId);

  /// Check if a user is a member
  Future<bool> isMember(String familyId);

  /// Check if a user is a member by email
  Future<bool> isMemberByEmail(String familyId, String email);

  // ============ Utility ============

  /// Get the current user ID
  Future<String> getCurrentUserId();

  /// Validate an invitation code
  Future<bool> validateInvitationCode(String code);

  /// Get invitation by code
  Future<FamilyInvitationModel?> getInvitationByCode(String code);
}
