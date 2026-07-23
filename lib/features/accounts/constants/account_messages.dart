/// Messages for the Accounts feature
class AccountMessages {
  // ============ Success Messages ============
  static const String accountCreated = 'Account created successfully! ✅';
  static const String accountUpdated = 'Account updated successfully! ✅';
  static const String accountDeleted = 'Account deleted successfully.';
  static const String accountArchived = 'Account archived successfully.';
  static const String accountRestored = 'Account restored successfully.';
  static const String transferCompleted = 'Transfer completed successfully! 💰';
  
  // ============ Error Messages ============
  static const String errorCreate = 'Failed to create account. Please try again.';
  static const String errorUpdate = 'Failed to update account. Please try again.';
  static const String errorDelete = 'Failed to delete account. Please try again.';
  static const String errorArchive = 'Failed to archive account. Please try again.';
  static const String errorRestore = 'Failed to restore account. Please try again.';
  static const String errorTransfer = 'Failed to complete transfer. Please try again.';
  static const String errorNetwork = 'Network connection issue. Please check your internet.';
  static const String errorServer = 'Server error. Please try again later.';
  
  // ============ Validation Messages ============
  static const String validationNameRequired = 'Account name is required.';
  static const String validationNameLength = 'Account name must be between 2 and 30 characters.';
  static const String validationNameInvalid = 'Account name contains invalid characters.';
  static const String validationBalanceInvalid = 'Please enter a valid amount.';
  static const String validationBalanceRange = 'Amount must be between -999,999.99 and 999,999.99.';
  static const String validationDuplicateName = 'An account with this name already exists.';
  static const String validationTransferAmount = 'Transfer amount must be greater than 0.';
  static const String validationInsufficientFunds = 'Insufficient funds in source account.';
  
  // ============ Confirmation Messages ============
  static const String confirmDelete = 'Are you sure you want to delete this account?';
  static const String confirmArchive = 'Are you sure you want to archive this account?';
  static const String confirmDeleteWithBalance = 'This account has a balance. Are you sure you want to delete it?';
  static const String confirmArchiveWithBalance = 'This account has a balance. Are you sure you want to archive it?';
  
  // ============ Info Messages ============
  static const String infoNoAccounts = 'No accounts yet. Create your first account!';
  static const String infoArchived = 'This account is archived and cannot be modified.';
  static const String infoTransfer = 'Transfer money between your accounts.';
  static const String infoBalance = 'Balance is calculated from all transactions.';
}
