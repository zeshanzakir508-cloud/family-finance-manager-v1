import '../constants/family_constants.dart';
import '../constants/family_messages.dart';

/// Validator for family-related data
class FamilyValidator {
  /// Validation result for family name
  static ValidationResult validateFamilyName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.validationFamilyNameRequired,
      );
    }

    final trimmed = name.trim();
    
    if (trimmed.length < FamilyConstants.minFamilyNameLength) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.validationFamilyNameLength,
      );
    }
    
    if (trimmed.length > FamilyConstants.maxFamilyNameLength) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.validationFamilyNameLength,
      );
    }

    // Check for invalid characters
    final regex = RegExp(FamilyConstants.familyNameRegex);
    if (!regex.hasMatch(trimmed)) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.validationFamilyNameInvalid,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate family description
  static ValidationResult validateDescription(String? description) {
    if (description == null) {
      return ValidationResult(isValid: true);
    }

    if (description.length > FamilyConstants.maxDescriptionLength) {
      return ValidationResult(
        isValid: false,
        message: 'Description must be less than ${FamilyConstants.maxDescriptionLength} characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate currency code
  static ValidationResult validateCurrency(String? currency) {
    if (currency == null || currency.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Currency is required',
      );
    }

    final supported = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR'];
    if (!supported.contains(currency.toUpperCase())) {
      return ValidationResult(
        isValid: false,
        message: 'Unsupported currency: $currency',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate family limit
  static ValidationResult validateFamilyLimit(int currentCount, int maxLimit) {
    if (currentCount >= maxLimit) {
      return ValidationResult(
        isValid: false,
        message: 'You have reached the maximum number of families ($maxLimit)',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate member limit
  static ValidationResult validateMemberLimit(int currentCount, int maxLimit) {
    if (currentCount >= maxLimit) {
      return ValidationResult(
        isValid: false,
        message: 'Family is full (maximum $maxLimit members)',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate ownership transfer
  static ValidationResult validateOwnershipTransfer(
    String currentOwnerId,
    String newOwnerId,
    List<MemberModel> members,
  ) {
    if (currentOwnerId == newOwnerId) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.errorCannotTransferToSelf,
      );
    }

    final newOwner = members.firstWhereOrNull((m) => m.id == newOwnerId);
    if (newOwner == null) {
      return ValidationResult(
        isValid: false,
        message: 'New owner not found',
      );
    }

    if (newOwner.status != MemberStatus.active) {
      return ValidationResult(
        isValid: false,
        message: 'New owner must be an active member',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate leaving family
  static ValidationResult validateLeaveFamily(bool isOnlyOwner, bool isOwner) {
    if (!isOwner) {
      return ValidationResult(
        isValid: false,
        message: 'Only family members can leave the family',
      );
    }

    if (isOnlyOwner) {
      return ValidationResult(
        isValid: false,
        message: FamilyMessages.errorLastOwner,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate family deletion
  static ValidationResult validateDeleteFamily(bool isOwner) {
    if (!isOwner) {
      return ValidationResult(
        isValid: false,
        message: 'Only the family owner can delete the family',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate role change
  static ValidationResult validateRoleChange(
    String memberId,
    FamilyRole currentRole,
    FamilyRole newRole,
    String currentUserId,
  ) {
    if (currentRole == FamilyRole.owner) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot change the owner\'s role',
      );
    }

    if (currentRole == newRole) {
      return ValidationResult(
        isValid: false,
        message: 'Member already has this role',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate member suspension
  static ValidationResult validateSuspendMember(FamilyRole role) {
    if (role == FamilyRole.owner) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot suspend the family owner',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate family switch
  static ValidationResult validateSwitchFamily(String familyId, List<FamilyModel> families) {
    final exists = families.any((f) => f.id == familyId);
    if (!exists) {
      return ValidationResult(
        isValid: false,
        message: 'Family not found or you are not a member',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate family name uniqueness
  static ValidationResult validateFamilyNameUnique(
    String name,
    List<FamilyModel> existingFamilies,
    {String? excludeId},
  ) {
    final exists = existingFamilies.any((f) =>
        f.name.toLowerCase() == name.toLowerCase() &&
        f.id != excludeId);
    
    if (exists) {
      return ValidationResult(
        isValid: false,
        message: 'A family with this name already exists',
      );
    }
    return ValidationResult(isValid: true);
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? message;

  const ValidationResult({
    required this.isValid,
    this.message,
  });
}
