import '../constants/transaction_constants.dart';
import '../enums/transaction_type.dart';

/// Validator for transaction-related data
class TransactionValidator {
  /// Validate transaction amount
  static ValidationResult validateAmount(double? amount) {
    if (amount == null) {
      return ValidationResult(
        isValid: false,
        message: 'Amount is required',
      );
    }

    if (amount < TransactionConstants.minAmount) {
      return ValidationResult(
        isValid: false,
        message: 'Amount must be at least ${TransactionConstants.minAmount}',
      );
    }

    if (amount > TransactionConstants.maxAmount) {
      return ValidationResult(
        isValid: false,
        message: 'Amount exceeds maximum limit',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate transaction amount from string input
  static ValidationResult validateAmountString(String? amountString) {
    if (amountString == null || amountString.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Amount is required',
      );
    }

    final double? amount = double.tryParse(amountString.trim());
    if (amount == null) {
      return ValidationResult(
        isValid: false,
        message: 'Please enter a valid amount',
      );
    }

    return validateAmount(amount);
  }

  /// Validate transaction note/description
  static ValidationResult validateNote(String? note) {
    if (note == null) {
      return ValidationResult(isValid: true);
    }

    if (note.length > TransactionConstants.maxNoteLength) {
      return ValidationResult(
        isValid: false,
        message: 'Note must be less than ${TransactionConstants.maxNoteLength} characters',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate transaction date
  static ValidationResult validateDate(DateTime? date) {
    if (date == null) {
      return ValidationResult(
        isValid: false,
        message: 'Date is required',
      );
    }

    if (date.isAfter(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: 'Date cannot be in the future',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate account selection
  static ValidationResult validateAccount(String? accountId) {
    if (accountId == null || accountId.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: TransactionConstants.errorAccountRequired,
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate category selection
  static ValidationResult validateCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: TransactionConstants.errorCategoryRequired,
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate transfer accounts (for transfer type)
  static ValidationResult validateTransferAccounts(
    String? fromAccountId,
    String? toAccountId,
  ) {
    if (fromAccountId == null || fromAccountId.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Source account is required',
      );
    }

    if (toAccountId == null || toAccountId.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Destination account is required',
      );
    }

    if (fromAccountId == toAccountId) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot transfer to the same account',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate transaction type
  static ValidationResult validateType(TransactionType? type) {
    if (type == null) {
      return ValidationResult(
        isValid: false,
        message: 'Transaction type is required',
      );
    }
    return ValidationResult(isValid: true);
  }

  /// Validate category for transaction type
  static ValidationResult validateCategoryForType(
    String? categoryId,
    TransactionType type,
  ) {
    if (type == TransactionType.transfer) {
      return ValidationResult(isValid: true);
    }

    return validateCategory(categoryId);
  }

  /// Validate account for transaction type
  static ValidationResult validateAccountForType(
    String? accountId,
    TransactionType type,
    String? fromAccountId,
    String? toAccountId,
  ) {
    if (type == TransactionType.transfer) {
      return validateTransferAccounts(fromAccountId, toAccountId);
    }
    return validateAccount(accountId);
  }

  /// Validate duplicate transaction
  static ValidationResult validateDuplicate(
    double amount,
    DateTime date,
    String accountId,
    String categoryId,
    List<TransactionModel> existingTransactions,
  ) {
    final duplicates = existingTransactions.where((t) =>
      t.amount.abs() == amount.abs() &&
      t.date.day == date.day &&
      t.date.month == date.month &&
      t.date.year == date.year &&
      t.accountId == accountId &&
      t.categoryId == categoryId
    ).toList();

    if (duplicates.isNotEmpty) {
      return ValidationResult(
        isValid: false,
        message: TransactionConstants.errorDuplicateTransaction,
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Validate transaction update
  static ValidationResult validateUpdate(
    TransactionModel transaction,
    String? accountId,
    String? categoryId,
  ) {
    // Check if account changed
    if (accountId != null && accountId != transaction.accountId) {
      // Check if account has enough balance if reducing
      // This would require checking the account balance
    }

    return ValidationResult(isValid: true);
  }

  /// Validate recurring transaction
  static ValidationResult validateRecurring({
    bool isRecurring = false,
    DateTime? endDate,
    int? frequency,
  }) {
    if (!isRecurring) {
      return ValidationResult(isValid: true);
    }

    if (endDate != null && endDate.isBefore(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: 'End date must be in the future',
      );
    }

    if (frequency != null && frequency <= 0) {
      return ValidationResult(
        isValid: false,
        message: 'Frequency must be greater than 0',
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
