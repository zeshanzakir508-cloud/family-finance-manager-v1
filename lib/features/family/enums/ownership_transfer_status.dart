/// Enum representing the status of an ownership transfer
enum OwnershipTransferStatus {
  pending,
  accepted,
  rejected,
  cancelled,
  expired,
}

/// Extension methods for OwnershipTransferStatus
extension OwnershipTransferStatusExtension on OwnershipTransferStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case OwnershipTransferStatus.pending:
        return 'Pending';
      case OwnershipTransferStatus.accepted:
        return 'Accepted';
      case OwnershipTransferStatus.rejected:
        return 'Rejected';
      case OwnershipTransferStatus.cancelled:
        return 'Cancelled';
      case OwnershipTransferStatus.expired:
        return 'Expired';
    }
  }

  /// Get the description for the status
  String get description {
    switch (this) {
      case OwnershipTransferStatus.pending:
        return 'Waiting for the new owner to accept';
      case OwnershipTransferStatus.accepted:
        return 'Ownership transfer completed';
      case OwnershipTransferStatus.rejected:
        return 'Transfer was rejected by the new owner';
      case OwnershipTransferStatus.cancelled:
        return 'Transfer was cancelled by the current owner';
      case OwnershipTransferStatus.expired:
        return 'Transfer request has expired';
    }
  }

  /// Get the color for the status
  String get colorHex {
    switch (this) {
      case OwnershipTransferStatus.pending:
        return '#FFC107';
      case OwnershipTransferStatus.accepted:
        return '#4CAF50';
      case OwnershipTransferStatus.rejected:
        return '#F44336';
      case OwnershipTransferStatus.cancelled:
        return '#9E9E9E';
      case OwnershipTransferStatus.expired:
        return '#9E9E9E';
    }
  }

  /// Check if the transfer is active
  bool get isActive {
    return this == OwnershipTransferStatus.pending;
  }

  /// Check if the transfer is terminal
  bool get isTerminal {
    return this == OwnershipTransferStatus.accepted || 
           this == OwnershipTransferStatus.rejected || 
           this == OwnershipTransferStatus.cancelled || 
           this == OwnershipTransferStatus.expired;
  }

  /// Check if the transfer can be cancelled
  bool get canBeCancelled {
    return this == OwnershipTransferStatus.pending;
  }

  /// Get the status from string value
  static OwnershipTransferStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => OwnershipTransferStatus.pending,
    );
  }

  /// Get all statuses
  static List<OwnershipTransferStatus> get allStatuses => values;

  /// Get active statuses
  static List<OwnershipTransferStatus> get activeStatuses =>
      values.where((status) => status.isActive).toList();

  /// Get terminal statuses
  static List<OwnershipTransferStatus> get terminalStatuses =>
      values.where((status) => status.isTerminal).toList();

  /// Parse status from string (case-insensitive)
  static OwnershipTransferStatus parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
      if (status.displayName.toLowerCase() == lowerValue) {
        return status;
      }
    }
    return OwnershipTransferStatus.pending;
  }
}
