import '../models/family_invitation_model.dart';
import '../models/family_activity_model.dart';
import '../models/family_statistics_model.dart';
import '../enums/family_role.dart';
import '../enums/family_status.dart';
import '../services/family_service.dart';

/// Repository for family data operations
class FamilyRepository {
  final FamilyService _service;

  FamilyRepository(this._service);

  // ============ Family CRUD Operations ============

  /// Get a family by ID
  Future<FamilyModel> getFamily(String familyId) async {
    return await _service.getFamily(familyId);
  }

  /// Get all families for the current user
  Future<List<FamilyModel>> getUserFamilies() async {
    return await _service.getUserFamilies();
  }

  /// Create a new family
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  }) async {
    return await _service.createFamily(
      name: name,
      description: description,
      currency: currency,
      timezone: timezone,
      country: country,
      language: language,
    );
  }

  /// Update a family
  Future<void> updateFamily(
    String familyId, {
    String? name,
    String? description,
    String? currency,
    String? timezone,
    String? country,
    String? language,
  }) async {
    await _service.updateFamily(
      familyId,
      name: name,
      description: description,
      currency: currency,
      timezone: timezone,
      country: country,
      language: language,
    );
  }

  /// Delete a family
  Future<void> deleteFamily(String familyId) async {
    await _service.deleteFamily(familyId);
  }

  /// Archive a family
  Future<void> archiveFamily(String familyId) async {
    await _service.archiveFamily(familyId);
  }

  /// Unarchive a family
  Future<void> unarchiveFamily(String familyId) async {
    await _service.unarchiveFamily(familyId);
  }

  // ============ Current Family Management ============

  /// Get the current family ID
  Future<String?> getCurrentFamilyId() async {
    return await _service.getCurrentFamilyId();
  }

  /// Set the current family ID
  Future<void> setCurrentFamilyId(String? familyId) async {
    await _service.setCurrentFamilyId(familyId);
  }

  // ============ Member Management ============

  /// Invite a member to a family
  Future<FamilyInvitationModel> inviteMember({
    required String familyId,
    required String email,
    String? name,
    FamilyRole role = FamilyRole.member,
  }) async {
    return await _service.inviteMember(
      familyId: familyId,
      email: email,
      name: name,
      role: role,
    );
  }

  /// Remove a member from a family
  Future<void> removeMember(String familyId, String memberId) async {
    await _service.removeMember(familyId, memberId);
  }

  /// Change a member's role
  Future<void> changeRole(String familyId, String memberId, FamilyRole newRole) async {
    await _service.changeRole(familyId, memberId, newRole);
  }

  /// Transfer ownership to another member
  Future<void> transferOwnership(String familyId, String newOwnerId) async {
    await _service.transferOwnership(familyId, newOwnerId);
  }

  /// Leave a family
  Future<void> leaveFamily(String familyId) async {
    await _service.leaveFamily(familyId);
  }

  // ============ Invitation Management ============

  /// Get all invitations for a family
  Future<List<FamilyInvitationModel>> getFamilyInvitations(String familyId) async {
    return await _service.getFamilyInvitations(familyId);
  }

  /// Create an invitation
  Future<FamilyInvitationModel> createInvitation({
    required String familyId,
    required String email,
    String? name,
    String role = 'member',
  }) async {
    return await _service.createInvitation(
      familyId: familyId,
      email: email,
      name: name,
      role: role,
    );
  }

  /// Accept an invitation
  Future<bool> acceptInvitation(String code) async {
    return await _service.acceptInvitation(code);
  }

  /// Reject an invitation
  Future<void> rejectInvitation(String code) async {
    await _service.rejectInvitation(code);
  }

  /// Cancel an invitation
  Future<void> cancelInvitation(String invitationId) async {
    await _service.cancelInvitation(invitationId);
  }

  /// Resend an invitation
  Future<void> resendInvitation(String invitationId) async {
    await _service.resendInvitation(invitationId);
  }

  // ============ Activity Management ============

  /// Get family activities
  Future<List<FamilyActivityModel>> getFamilyActivities(
    String familyId, {
    int limit = 50,
    DateTime? after,
  }) async {
    return await _service.getFamilyActivities(
      familyId,
      limit: limit,
      after: after,
    );
  }

  /// Add a family activity
  Future<void> addActivity(FamilyActivityModel activity) async {
    await _service.addActivity(activity);
  }

  // ============ Statistics ============

  /// Get family statistics
  Future<FamilyStatisticsModel> getFamilyStatistics(String familyId) async {
    return await _service.getFamilyStatistics(familyId);
  }

  // ============ Permission Checks ============

  /// Check if a user has a specific permission
  Future<bool> hasPermission(String familyId, String permission) async {
    return await _service.hasPermission(familyId, permission);
  }

  /// Check if a user is the owner
  Future<bool> isOwner(String familyId) async {
    return await _service.isOwner(familyId);
  }

  /// Check if a user is the only owner
  Future<bool> isOnlyOwner(String familyId) async {
    return await _service.isOnlyOwner(familyId);
  }

  /// Check if a user is a member
  Future<bool> isMember(String familyId) async {
    return await _service.isMember(familyId);
  }

  /// Check if a user is a member by email
  Future<bool> isMemberByEmail(String familyId, String email) async {
    return await _service.isMemberByEmail(familyId, email);
  }

  // ============ Utility ============

  /// Get the current user ID
  Future<String> getCurrentUserId() async {
    return await _service.getCurrentUserId();
  }

  /// Validate an invitation code
  Future<bool> validateInvitationCode(String code) async {
    return await _service.validateInvitationCode(code);
  }

  /// Get invitation by code
  Future<FamilyInvitationModel?> getInvitationByCode(String code) async {
    return await _service.getInvitationByCode(code);
  }
}
