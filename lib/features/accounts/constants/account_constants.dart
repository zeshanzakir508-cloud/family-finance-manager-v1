/// Constants for the Accounts feature
class AccountConstants {
  /// Maximum account name length
  static const int maxAccountNameLength = 30;
  
  /// Minimum account name length
  static const int minAccountNameLength = 2;
  
  /// Maximum account description length
  static const int maxDescriptionLength = 200;
  
  /// Minimum opening balance
  static const double minOpeningBalance = -999999.99;
  
  /// Maximum opening balance
  static const double maxOpeningBalance = 999999.99;
  
  /// Default account name
  static const String defaultAccountName = 'Main Account';
  
  /// SharedPreferences keys
  static const String keySelectedAccountId = 'selected_account_id';
  
  /// Firebase collection names
  static const String collectionAccounts = 'accounts';
  
  /// Cache durations
  static const Duration cacheDuration = Duration(minutes: 5);
  
  /// Debounce delays
  static const Duration debounceDelay = Duration(milliseconds: 300);
  
  /// Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  /// Error messages
  static const String errorAccountNotFound = 'Account not found';
  static const String errorDuplicateName = 'An account with this name already exists';
  static const String errorInvalidBalance = 'Invalid balance amount';
  static const String errorCannotDeleteWithBalance = 'Cannot delete account with balance';
  static const String errorCannotArchiveWithBalance = 'Cannot archive account with balance';
  static const String errorInsufficientFunds = 'Insufficient funds for transfer';
  static const String errorSameAccount = 'Cannot transfer to the same account';
  static const String errorTransferLimit = 'Transfer amount exceeds limit';
  static const String errorAccountArchived = 'Cannot perform action on archived account';
  
  /// Account icon options
  static const List<String> accountIcons = [
    'wallet',
    'bank',
    'cash',
    'credit_card',
    'savings',
    'investment',
    'piggy_bank',
    'money_bag',
  ];
  
  /// Account color options
  static const List<String> accountColors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4',
    '#FF9F43', '#A29BFE', '#FD79A8', '#00CEC9',
    '#FDCB6E', '#6C5CE7', '#00B894', '#E17055'
  ];
  
  /// Icon mapping
  static const Map<String, String> iconMapping = {
    'wallet': '💰',
    'bank': '🏦',
    'cash': '💵',
    'credit_card': '💳',
    'savings': '🏺',
    'investment': '📈',
    'piggy_bank': '🐷',
    'money_bag': '💰',
  };
}
