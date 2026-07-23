/// Enum representing member roles in a family
enum FamilyRole {
  owner,
  moderator,
  member,
  viewer,
}

/// Extension methods for FamilyRole
extension FamilyRoleExtension on FamilyRole {
  /// Get the display name for the role
  String get displayName {
    switch (this) {
      case FamilyRole.owner:
        return 'Owner';
      case FamilyRole.moderator:
        return 'Moderator';
      case FamilyRole.member:
        return 'Member';
      case FamilyRole.viewer:
        return 'Viewer';
    }
  }

  /// Get the description for the role
  String get description {
    switch (this) {
      case FamilyRole.owner:
        return 'Full control over the family and all settings';
      case FamilyRole.moderator:
        return 'Can manage members and family content';
      case FamilyRole.member:
        return 'Can participate in family activities';
      case FamilyRole.viewer:
        return 'Read-only access to family data';
    }
  }

  /// Get the priority level (higher = more permissions)
  int get priority {
    switch (this) {
      case FamilyRole.owner:
        return 4;
      case FamilyRole.moderator:
        return 3;
      case FamilyRole.member:
        return 2;
      case FamilyRole.viewer:
        return 1;
    }
  }

  /// Check if this role has higher priority than another
  bool isHigherThan(FamilyRole other) {
    return priority > other.priority;
  }

  /// Check if this role has lower priority than another
  bool isLowerThan(FamilyRole other) {
    return priority < other.priority;
  }

  /// Check if this role is at least as high as another
  bool isAtLeast(FamilyRole other) {
    return priority >= other.priority;
  }

  /// Get the color for the role
  String get colorHex {
    switch (this) {
      case FamilyRole.owner:
        return '#FF6B6B';
      case FamilyRole.moderator:
        return '#4ECDC4';
      case FamilyRole.member:
        return '#45B7D1';
      case FamilyRole.viewer:
        return '#96CEB4';
    }
  }

  /// Get the icon for the role
  String get iconName {
    switch (this) {
      case FamilyRole.owner:
        return 'crown';
      case FamilyRole.moderator:
        return 'shield';
      case FamilyRole.member:
        return 'person';
      case FamilyRole.viewer:
        return 'visibility';
    }
  }

  /// Get the role from string value
  static FamilyRole fromString(String value) {
    return values.firstWhere(
      (role) => role.name == value,
      orElse: () => FamilyRole.member,
    );
  }

  /// Check if this role can perform administrative actions
  bool get isAdmin {
    return this == FamilyRole.owner || this == FamilyRole.moderator;
  }

  /// Check if this role can manage members
  bool get canManageMembers {
    return this == FamilyRole.owner || this == FamilyRole.moderator;
  }

  /// Check if this role can manage settings
  bool get canManageSettings {
    return this == FamilyRole.owner || this == FamilyRole.moderator;
  }

  /// Check if this role can delete the family
  bool get canDeleteFamily {
    return this == FamilyRole.owner;
  }

  /// Check if this role can transfer ownership
  bool get canTransferOwnership {
    return this == FamilyRole.owner;
  }

  /// Get all roles as a list
  static List<FamilyRole> get allRoles => values;

  /// Get admin roles
  static List<FamilyRole> get adminRoles =>
      values.where((role) => role.isAdmin).toList();

  /// Get non-admin roles
  static List<FamilyRole> get nonAdminRoles =>
      values.where((role) => !role.isAdmin).toList();

  /// Get roles that can manage members
  static List<FamilyRole> get memberManagingRoles =>
      values.where((role) => role.canManageMembers).toList();

  /// Parse role from string (case-insensitive)
  static FamilyRole parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final role in values) {
      if (role.name.toLowerCase() == lowerValue) {
        return role;
      }
      if (role.displayName.toLowerCase() == lowerValue) {
        return role;
      }
    }
    return FamilyRole.member;
  }
}
