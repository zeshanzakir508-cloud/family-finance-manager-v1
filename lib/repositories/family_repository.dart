import '../models/family_member_model.dart';
import '../models/family_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Family Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing families and their members.
///
/// Responsibilities:
/// • Create family
/// • Read family
/// • Update family
/// • Soft delete family
/// • Restore family
/// • Manage family members
/// • Manage invitations
/// • Transfer ownership
/// • Watch family changes
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class FamilyRepository {
  //==========================================================================
  // Family
  //==========================================================================

  /// Creates a new family.
  Future<void> createFamily(FamilyModel family);

  /// Returns a family by its ID.
  Future<FamilyModel?> getFamily(String familyId);

  /// Watches a family for real-time updates.
  Stream<FamilyModel?> watchFamily(String familyId);

  /// Updates a family.
  Future<void> updateFamily(FamilyModel family);

  /// Soft deletes a family.
  Future<void> deleteFamily(String familyId);

  /// Restores a deleted family.
  Future<void> restoreFamily(String familyId);

  /// Returns true if the family exists.
  Future<bool> familyExists(String familyId);

  //==========================================================================
  // Family Members
  //==========================================================================

  /// Returns all members of a family.
  Future<List<FamilyMemberModel>> getMembers(String familyId);

  /// Watches all members of a family.
  Stream<List<FamilyMemberModel>> watchMembers(String familyId);

  /// Adds a member to the family.
  Future<void> addMember(FamilyMemberModel member);

  /// Updates a family member.
  Future<void> updateMember(FamilyMemberModel member);

  /// Removes a member from the family.
  Future<void> removeMember({
    required String familyId,
    required String userId,
  });

  /// Returns true if the user belongs to the family.
  Future<bool> isMember({
    required String familyId,
    required String userId,
  });

  //==========================================================================
  // Ownership
  //==========================================================================

  /// Transfers ownership of the family.
  Future<void> transferOwnership({
    required String familyId,
    required String newOwnerUserId,
  });

  //==========================================================================
  // Invitations
  //==========================================================================

  /// Sends an invitation to join the family.
  Future<void> inviteMember({
    required String familyId,
    required String email,
  });

  /// Accepts a family invitation.
  Future<void> acceptInvitation({
    required String invitationId,
  });

  /// Rejects a family invitation.
  Future<void> rejectInvitation({
    required String invitationId,
  });

  /// Cancels a pending invitation.
  Future<void> cancelInvitation({
    required String invitationId,
  });
}
