import '../models/family_invitation_model.dart';
import '../enums/invite_status.dart';

/// Interface for invitation service operations
abstract class InvitationService {
  /// Create a new invitation
  Future<FamilyInvitationModel> createInvitation({
    required String familyId,
    required String email,
    String? name,
    String role = 'member',
  });

  /// Get an invitation by ID
  Future<FamilyInvitationModel?> getInvitation(String invitationId);

  /// Get an invitation by code
  Future<FamilyInvitationModel?> getInvitationByCode(String code);

  /// Get all invitations for a family
  Future<List<FamilyInvitationModel>> getFamilyInvitations(String familyId);

  /// Get invitations by status
  Future<List<FamilyInvitationModel>> getInvitationsByStatus(String familyId, InviteStatus status);

  /// Get pending invitations for a family
  Future<List<FamilyInvitationModel>> getPendingInvitations(String familyId);

  /// Accept an invitation
  Future<bool> acceptInvitation(String code);

  /// Reject an invitation
  Future<void> rejectInvitation(String code);

  /// Cancel an invitation
  Future<void> cancelInvitation(String invitationId);

  /// Resend an invitation
  Future<void> resendInvitation(String invitationId);

  /// Check if an invitation is valid
  Future<bool> isValidInvitation(String code);

  /// Check if an invitation has expired
  Future<bool> isInvitationExpired(String code);

  /// Check if an email has a pending invitation
  Future<bool> hasPendingInvitation(String familyId, String email);

  /// Get invitation count by status
  Future<Map<InviteStatus, int>> getInvitationCountByStatus(String familyId);

  /// Get total invitation count
  Future<int> getInvitationCount(String familyId);

  /// Get pending invitation count
  Future<int> getPendingInvitationCount(String familyId);

  /// Expire old invitations
  Future<void> expireOldInvitations(String familyId);

  /// Clean up expired invitations
  Future<void> cleanupExpiredInvitations(String familyId);

  /// Get recent invitations (last N days)
  Future<List<FamilyInvitationModel>> getRecentInvitations(String familyId, {int days = 7});

  /// Get invitation statistics
  Future<Map<String, dynamic>> getInvitationStatistics(String familyId);

  /// Validate invitation code format
  bool isValidInvitationCode(String code);

  /// Generate a new invitation code
  String generateInvitationCode();

  /// Check if invitation can be resent
  Future<bool> canResendInvitation(String invitationId);
}
