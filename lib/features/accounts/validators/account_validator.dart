import '../constants/account_constants.dart';

/// Validator for account-related data
class AccountValidator {
  /// Validation result for account name
  static ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: AccountConstants.errorDuplicateName,
      );
    }

    final trimmed = name.trim();
    
    if (trimmed.length < AccountConstants.minAccountNameLength) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationNameLength,
      );
    }
    
    if (trimmed.length > AccountConstants.maxAccountNameLength) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationNameLength,
      );
    }

    // Check for invalid characters (only alphanumeric, spaces, and basic punctuation)
    final regex = RegExp(r'^[a-zA-Z0-9\s\-&\'"]{2,30}$');
    if (!regex.hasMatch(trimmed)) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationNameInvalid,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate account description
  static ValidationResult validateDescription(String? description) {
    if (description == null) {
      return ValidationResult(isValid: true);
    }

    if (description.length > AccountConstants.maxDescriptionLength) {
      return ValidationResult(
        isValid: false,
        message: 'Description must be less than ${AccountConstants.maxDescriptionLength} characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate opening balance
  static ValidationResult validateOpeningBalance(double? balance) {
    if (balance == null) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationBalanceInvalid,
      );
    }

    if (balance < AccountConstants.minOpeningBalance || 
        balance > AccountConstants.maxOpeningBalance) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationBalanceRange,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate opening balance from string input
  static ValidationResult validateOpeningBalanceString(String? balanceString) {
    if (balanceString == null || balanceString.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationBalanceInvalid,
      );
    }

    final double? balance = double.tryParse(balanceString.trim());
    if (balance == null) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationBalanceInvalid,
      );
    }

    return validateOpeningBalance(balance);
  }

  /// Validate duplicate account name
  static ValidationResult validateDuplicateName(
    String name,
    List<AccountModel> existingAccounts, {
    String? excludeId,
  }) {
    final exists = existingAccounts.any((a) =>
        a.name.toLowerCase() == name.toLowerCase() &&
        a.id != excludeId);
    
    if (exists) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationDuplicateName,
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate transfer amount
  static ValidationResult validateTransferAmount(double? amount) {
    if (amount == null) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationTransferAmount,
      );
    }

    if (amount <= 0) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationTransferAmount,
      );
    }

    if (amount > 999999.99) {
      return ValidationResult(
        isValid: false,
        message: 'Transfer amount exceeds maximum limit',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate transfer amount from string input
  static ValidationResult validateTransferAmountString(String? amountString) {
    if (amountString == null || amountString.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationTransferAmount,
      );
    }

    final double? amount = double.tryParse(amountString.trim());
    if (amount == null) {
      return ValidationResult(
        isValid: false,
        message: 'Please enter a valid amount',
      );
    }

    return validateTransferAmount(amount);
  }

  /// Validate sufficient funds for transfer
  static ValidationResult validateSufficientFunds(
    double sourceBalance,
    double amount,
  ) {
    if (sourceBalance < amount) {
      return ValidationResult(
        isValid: false,
        message: AccountMessages.validationInsufficientFunds,
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate accounts for transfer
  static ValidationResult validateTransferAccounts(
    AccountModel? fromAccount,
    AccountModel? toAccount,
  ) {
    if (fromAccount == null) {
      return ValidationResult(
        isValid: false,
        message: 'Please select a source account',
      );
    }

    if (toAccount == null) {
      return ValidationResult(
        isValid: false,
        message: 'Please select a destination account',
      );
    }

    if (fromAccount.id == toAccount.id) {
      return ValidationResult(
        isValid: false,
        message: AccountConstants.errorSameAccount,
      );
    }

    if (fromAccount.isArchived) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot transfer from an archived account',
      );
    }

    if (toAccount.isArchived) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot transfer to an archived account',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate account deletion
  static ValidationResult validateDeleteAccount(AccountModel account) {
    if (account.isArchived) {
      return ValidationResult(
        isValid: false,
        message: AccountConstants.errorAccountArchived,
      );
    }

    // Check if account has transactions
    if (account.hasBalance) {
      return ValidationResult(
        isValid: false,
        message: AccountConstants.errorCannotDeleteWithBalance,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate account archiving
  static ValidationResult validateArchiveAccount(AccountModel account) {
    if (account.isArchived) {
      return ValidationResult(
        isValid: false,
        message: 'Account is already archived',
      );
    }

    // Check if account has balance
    if (account.hasBalance) {
      return ValidationResult(
        isValid: false,
        message: AccountConstants.errorCannotArchiveWithBalance,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate account restoration
  static ValidationResult validateRestoreAccount(AccountModel account) {
    if (!account.isArchived) {
      return ValidationResult(
        isValid: false,
        message: 'Account is not archived',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate account search query
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

  /// Validate account filter
  static ValidationResult validateFilter(String? filter) {
    final validFilters = ['all', 'active', 'archived'];
    if (filter != null && !validFilters.contains(filter)) {
      return ValidationResult(
        isValid: false,
        message: 'Invalid filter option',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Get account validation summary
  static Map<String, dynamic> getValidationSummary(AccountModel account) {
    return {
      'isValid': true,
      'nameValid': validateName(account.name).isValid,
      'balanceValid': validateOpeningBalance(account.openingBalance).isValid,
      'isActive': account.isActive,
      'hasBalance': account.hasBalance,
    };
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
