/// Enum representing the status of a member in a family
enum MemberStatus {
  active,
  pending,
  suspended,
  blocked,
  removed,
  left,
}

/// Extension methods for MemberStatus
extension MemberStatusExtension on MemberStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case MemberStatus.active:
        return 'Active';
      case MemberStatus.pending:
        return 'Pending';
      case MemberStatus.suspended:
        return 'Suspended';
      case MemberStatus.blocked:
        return 'Blocked';
      case MemberStatus.removed:
        return 'Removed';
      case MemberStatus.left:
        return 'Left';
    }
  }

  /// Get the description for the status
  String get description {
    switch (this) {
      case MemberStatus.active:
        return 'Member is actively participating';
      case MemberStatus.pending:
        return 'Member has been invited but not yet joined';
      case MemberStatus.suspended:
        return 'Member is temporarily suspended';
      case MemberStatus.blocked:
        return 'Member has been blocked';
      case MemberStatus.removed:
        return 'Member has been removed';
      case MemberStatus.left:
        return 'Member has left voluntarily';
    }
  }

  /// Get the color for the status
  String get colorHex {
    switch (this) {
      case MemberStatus.active:
        return '#4CAF50';
      case MemberStatus.pending:
        return '#FFC107';
      case MemberStatus.suspended:
        return '#FF9800';
      case MemberStatus.blocked:
        return '#F44336';
      case MemberStatus.removed:
        return '#9E9E9E';
      case MemberStatus.left:
        return '#9E9E9E';
    }
  }

  /// Check if the member can access the family
  bool get canAccess {
    return this == MemberStatus.active;
  }

  /// Check if the member is in a terminal state
  bool get isTerminal {
    return this == MemberStatus.removed || 
           this == MemberStatus.left || 
           this == MemberStatus.blocked;
  }

  /// Check if the member can be restored
  bool get canBeRestored {
    return this == MemberStatus.suspended || 
           this == MemberStatus.blocked;
  }

  /// Check if the member can be removed
  bool get canBeRemoved {
    return this == MemberStatus.active || 
           this == MemberStatus.suspended || 
           this == MemberStatus.pending;
  }

  /// Check if the member can be suspended
  bool get canBeSuspended {
    return this == MemberStatus.active;
  }

  /// Check if the member is active and participating
  bool get isParticipating {
    return this == MemberStatus.active;
  }

  /// Get the status from string value
  static MemberStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => MemberStatus.active,
    );
  }

  /// Get all statuses
  static List<MemberStatus> get allStatuses => values;

  /// Get active statuses (members who can access)
  static List<MemberStatus> get activeStatuses =>
      values.where((status) => status.canAccess).toList();

  /// Get terminal statuses
  static List<MemberStatus> get terminalStatuses =>
      values.where((status) => status.isTerminal).toList();

  /// Parse status from string (case-insensitive)
  static MemberStatus parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
      if (status.displayName.toLowerCase() == lowerValue) {
        return status;
      }
    }
    return MemberStatus.active;
  }
}
