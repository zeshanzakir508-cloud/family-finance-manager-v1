import '../constants/family_constants.dart';
import '../enums/family_role.dart';
import '../enums/member_status.dart';

/// Validator for member-related data
class MemberValidator {
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

  /// Validate member name
  static ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Name is required',
      );
    }

    final trimmed = name.trim();
    if (trimmed.length < FamilyConstants.minMemberNameLength) {
      return ValidationResult(
        isValid: false,
        message: 'Name must be at least ${FamilyConstants.minMemberNameLength} characters',
      );
    }

    if (trimmed.length > FamilyConstants.maxMemberNameLength) {
      return ValidationResult(
        isValid: false,
        message: 'Name must be less than ${FamilyConstants.maxMemberNameLength} characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate role assignment
  static ValidationResult validateRoleAssignment(
    FamilyRole role,
    bool isOwner,
  ) {
    if (role == FamilyRole.owner && !isOwner) {
      return ValidationResult(
        isValid: false,
        message: 'Only the current owner can assign the owner role',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate member status change
  static ValidationResult validateStatusChange(
    MemberStatus currentStatus,
    MemberStatus newStatus,
    FamilyRole role,
  ) {
    if (role == FamilyRole.owner && newStatus != MemberStatus.active) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot change the owner\'s status',
      );
    }

    if (currentStatus == newStatus) {
      return ValidationResult(
        isValid: false,
        message: 'Member already has this status',
      );
    }

    // Validate specific transitions
    switch (newStatus) {
      case MemberStatus.suspended:
        if (currentStatus != MemberStatus.active) {
          return ValidationResult(
            isValid: false,
            message: 'Only active members can be suspended',
          );
        }
        break;
      case MemberStatus.blocked:
        if (currentStatus != MemberStatus.active && currentStatus != MemberStatus.suspended) {
          return ValidationResult(
            isValid: false,
            message: 'Only active or suspended members can be blocked',
          );
        }
        break;
      case MemberStatus.active:
        if (currentStatus != MemberStatus.suspended && currentStatus != MemberStatus.pending) {
          return ValidationResult(
            isValid: false,
            message: 'Only suspended or pending members can be restored',
          );
        }
        break;
      default:
        break;
    }

    return ValidationResult(isValid: true);
  }

  /// Validate member removal
  static ValidationResult validateRemoveMember(FamilyRole role, bool isOwner) {
    if (role == FamilyRole.owner) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot remove the family owner',
      );
    }

    if (!isOwner) {
      return ValidationResult(
        isValid: false,
        message: 'Only the owner can remove members',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate member invitation
  static ValidationResult validateInviteMember(
    String email,
    bool isAlreadyMember,
    bool hasPendingInvite,
    int currentMemberCount,
    int maxMembers,
  ) {
    // Check email format
    final emailValidation = validateEmail(email);
    if (!emailValidation.isValid) {
      return emailValidation;
    }

    // Check if already a member
    if (isAlreadyMember) {
      return ValidationResult(
        isValid: false,
        message: 'This user is already a member of the family',
      );
    }

    // Check for pending invitation
    if (hasPendingInvite) {
      return ValidationResult(
        isValid: false,
        message: 'An invitation has already been sent to this email',
      );
    }

    // Check member limit
    if (currentMemberCount >= maxMembers) {
      return ValidationResult(
        isValid: false,
        message: 'Family is full (maximum $maxMembers members)',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate member search query
  static ValidationResult validateSearchQuery(String? query) {
    if (query == null || query.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Search query is required',
      );
    }

    if (query.trim().length < 2) {
      return ValidationResult(
        isValid: false,
        message: 'Search query must be at least 2 characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Check if a member can perform an action
  static bool canPerformAction(
    MemberModel member,
    String action,
    FamilyRole requiredRole,
  ) {
    // Owner can do everything
    if (member.role == FamilyRole.owner) return true;
    
    // Check role-based permissions
    switch (action) {
      case 'invite_member':
        return member.role == FamilyRole.moderator;
      case 'remove_member':
        return member.role == FamilyRole.moderator;
      case 'change_role':
        return false; // Only owner can change roles
      case 'suspend_member':
        return member.role == FamilyRole.moderator;
      case 'restore_member':
        return member.role == FamilyRole.moderator;
      case 'manage_settings':
        return member.role == FamilyRole.moderator;
      default:
        return false;
    }
  }
}
