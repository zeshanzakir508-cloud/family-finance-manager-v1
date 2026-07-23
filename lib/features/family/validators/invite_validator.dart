import '../constants/family_constants.dart';
import '../enums/invite_status.dart';

/// Validator for invitation-related data
class InviteValidator {
  /// Validate email format
  static ValidationResult validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Email is required',
      );
    }

    final trimmed = email.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(trimmed)) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid email format',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation code
  static ValidationResult validateInvitationCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation code is required',
      );
    }

    final trimmed = code.trim().toUpperCase();
    final regex = RegExp(FamilyConstants.inviteCodeRegex);
    
    if (!regex.hasMatch(trimmed)) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid invitation code format',
      );
    }

    if (trimmed.length != FamilyConstants.inviteCodeLength) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation code must be ${FamilyConstants.inviteCodeLength} characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation for acceptance
  static ValidationResult validateAcceptInvitation(
    FamilyInvitationModel? invitation,
  ) {
    if (invitation == null) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation not found',
      );
    }

    if (invitation.status != InviteStatus.pending) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation is no longer valid',
      );
    }

    if (invitation.isExpired) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation has expired',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation resend
  static ValidationResult validateResendInvitation(
    FamilyInvitationModel? invitation,
    int maxAttempts,
  ) {
    if (invitation == null) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation not found',
      );
    }

    if (invitation.status != InviteStatus.pending && 
        invitation.status != InviteStatus.expired) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot resend this invitation',
      );
    }

    if (invitation.resendCount >= maxAttempts) {
      return ValidationResult(
        isValid: false,
        message: 'Maximum resend attempts reached ($maxAttempts)',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation cancel
  static ValidationResult validateCancelInvitation(
    FamilyInvitationModel? invitation,
  ) {
    if (invitation == null) {
      return ValidationResult(
        isValid: false,
        message: 'Invitation not found',
      );
    }

    if (invitation.status != InviteStatus.pending) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot cancel this invitation',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation expiry
  static ValidationResult validateExpiryDate(DateTime? expiresAt) {
    if (expiresAt == null) {
      return ValidationResult(
        isValid: false,
        message: 'Expiry date is required',
      );
    }

    if (expiresAt.isBefore(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: 'Expiry date must be in the future',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate invitation count
  static ValidationResult validateInvitationCount(
    int currentCount,
    int maxCount,
  ) {
    if (currentCount >= maxCount) {
      return ValidationResult(
        isValid: false,
        message: 'Maximum pending invitations reached ($maxCount)',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate role in invitation
  static ValidationResult validateInvitationRole(String role) {
    final validRoles = ['owner', 'moderator', 'member', 'viewer'];
    if (!validRoles.contains(role.toLowerCase())) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid role: $role',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate if an invitation is active
  static bool isInvitationActive(FamilyInvitationModel invitation) {
    return invitation.status == InviteStatus.pending && 
           !invitation.isExpired;
  }

  /// Check if invitation can be used
  static bool canUseInvitation(FamilyInvitationModel invitation) {
    return invitation.status == InviteStatus.pending && 
           !invitation.isExpired;
  }
}
