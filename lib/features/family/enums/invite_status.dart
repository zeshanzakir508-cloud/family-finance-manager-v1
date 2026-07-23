/// Enum representing the status of a family invitation
enum InviteStatus {
  pending,
  accepted,
  rejected,
  expired,
  cancelled,
}

/// Extension methods for InviteStatus
extension InviteStatusExtension on InviteStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case InviteStatus.pending:
        return 'Pending';
      case InviteStatus.accepted:
        return 'Accepted';
      case InviteStatus.rejected:
        return 'Rejected';
      case InviteStatus.expired:
        return 'Expired';
      case InviteStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get the description for the status
  String get description {
    switch (this) {
      case InviteStatus.pending:
        return 'Invitation is waiting for response';
      case InviteStatus.accepted:
        return 'Invitation has been accepted';
      case InviteStatus.rejected:
        return 'Invitation has been rejected';
      case InviteStatus.expired:
        return 'Invitation has expired';
      case InviteStatus.cancelled:
        return 'Invitation has been cancelled';
    }
  }

  /// Get the color for the status
  String get colorHex {
    switch (this) {
      case InviteStatus.pending:
        return '#FFC107';
      case InviteStatus.accepted:
        return '#4CAF50';
      case InviteStatus.rejected:
        return '#F44336';
      case InviteStatus.expired:
        return '#9E9E9E';
      case InviteStatus.cancelled:
        return '#9E9E9E';
    }
  }

  /// Check if the invite is still active
  bool get isActive {
    return this == InviteStatus.pending;
  }

  /// Check if the invite is terminal
  bool get isTerminal {
    return this == InviteStatus.accepted || 
           this == InviteStatus.rejected || 
           this == InviteStatus.expired || 
           this == InviteStatus.cancelled;
  }

  /// Check if the invite can be cancelled
  bool get canBeCancelled {
    return this == InviteStatus.pending;
  }

  /// Check if the invite can be resent
  bool get canBeResent {
    return this == InviteStatus.pending || 
           this == InviteStatus.expired || 
           this == InviteStatus.cancelled;
  }

  /// Get the status from string value
  static InviteStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => InviteStatus.pending,
    );
  }

  /// Get all statuses
  static List<InviteStatus> get allStatuses => values;

  /// Get active statuses
  static List<InviteStatus> get activeStatuses =>
      values.where((status) => status.isActive).toList();

  /// Get terminal statuses
  static List<InviteStatus> get terminalStatuses =>
      values.where((status) => status.isTerminal).toList();

  /// Parse status from string (case-insensitive)
  static InviteStatus parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
      if (status.displayName.toLowerCase() == lowerValue) {
        return status;
      }
    }
    return InviteStatus.pending;
  }
}
