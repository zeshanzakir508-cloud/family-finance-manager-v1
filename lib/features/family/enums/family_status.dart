/// Enum representing the status of a family
enum FamilyStatus {
  active,
  archived,
  deleted,
}

/// Extension methods for FamilyStatus
extension FamilyStatusExtension on FamilyStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case FamilyStatus.active:
        return 'Active';
      case FamilyStatus.archived:
        return 'Archived';
      case FamilyStatus.deleted:
        return 'Deleted';
    }
  }

  /// Get the description for the status
  String get description {
    switch (this) {
      case FamilyStatus.active:
        return 'Family is active and fully functional';
      case FamilyStatus.archived:
        return 'Family is archived and read-only';
      case FamilyStatus.deleted:
        return 'Family has been deleted';
    }
  }

  /// Get the color for the status
  String get colorHex {
    switch (this) {
      case FamilyStatus.active:
        return '#4CAF50';
      case FamilyStatus.archived:
        return '#FF9800';
      case FamilyStatus.deleted:
        return '#F44336';
    }
  }

  /// Check if the family is accessible
  bool get isAccessible {
    return this == FamilyStatus.active;
  }

  /// Check if the family is deletable
  bool get isDeletable {
    return this != FamilyStatus.deleted;
  }

  /// Check if the family is editable
  bool get isEditable {
    return this == FamilyStatus.active;
  }

  /// Get the status from string value
  static FamilyStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => FamilyStatus.active,
    );
  }

  /// Get all statuses
  static List<FamilyStatus> get allStatuses => values;

  /// Parse status from string (case-insensitive)
  static FamilyStatus parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
      if (status.displayName.toLowerCase() == lowerValue) {
        return status;
      }
    }
    return FamilyStatus.active;
  }
}
