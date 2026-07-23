/// Enum representing the status of a transaction
enum TransactionStatus {
  pending,
  completed,
  cancelled,
  failed,
}

/// Extension methods for TransactionStatus
extension TransactionStatusExtension on TransactionStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  /// Get the icon for the status
  String get iconName {
    switch (this) {
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.completed:
        return 'check_circle';
      case TransactionStatus.cancelled:
        return 'cancel';
      case TransactionStatus.failed:
        return 'error';
    }
  }

  /// Get the color for the status
  String get colorHex {
    switch (this) {
      case TransactionStatus.pending:
        return '#FFC107';
      case TransactionStatus.completed:
        return '#4CAF50';
      case TransactionStatus.cancelled:
        return '#9E9E9E';
      case TransactionStatus.failed:
        return '#F44336';
    }
  }

  /// Check if the transaction is active (pending or completed)
  bool get isActive {
    return this == TransactionStatus.pending || 
           this == TransactionStatus.completed;
  }

  /// Check if the transaction is final (completed, cancelled, or failed)
  bool get isFinal {
    return this == TransactionStatus.completed || 
           this == TransactionStatus.cancelled || 
           this == TransactionStatus.failed;
  }

  /// Check if the transaction is successful
  bool get isSuccessful {
    return this == TransactionStatus.completed;
  }

  /// Get the status from string value
  static TransactionStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => TransactionStatus.pending,
    );
  }

  /// Get all statuses
  static List<TransactionStatus> get allStatuses => values;

  /// Get active statuses
  static List<TransactionStatus> get activeStatuses =>
      values.where((s) => s.isActive).toList();

  /// Get final statuses
  static List<TransactionStatus> get finalStatuses =>
      values.where((s) => s.isFinal).toList();

  /// Parse status from string (case-insensitive)
  static TransactionStatus parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
      if (status.displayName.toLowerCase() == lowerValue) {
        return status;
      }
    }
    return TransactionStatus.pending;
  }
}
