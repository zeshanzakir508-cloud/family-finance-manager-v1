/// Constants for the Transactions feature
class TransactionConstants {
  /// Maximum note length
  static const int maxNoteLength = 200;
  
  /// Minimum amount
  static const double minAmount = 0.01;
  
  /// Maximum amount
  static const double maxAmount = 9999999.99;
  
  /// Default transaction description
  static const String defaultDescription = '';
  
  /// SharedPreferences keys
  static const String keyTransactionFilter = 'transaction_filter';
  static const String keyTransactionSort = 'transaction_sort';
  
  /// Firebase collection names
  static const String collectionTransactions = 'transactions';
  static const String collectionRecurring = 'recurring_transactions';
  
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
  static const String errorTransactionNotFound = 'Transaction not found';
  static const String errorInvalidAmount = 'Invalid amount';
  static const String errorInsufficientFunds = 'Insufficient funds';
  static const String errorInvalidDate = 'Invalid date';
  static const String errorCategoryRequired = 'Category is required';
  static const String errorAccountRequired = 'Account is required';
  static const String errorDuplicateTransaction = 'Duplicate transaction detected';
}
