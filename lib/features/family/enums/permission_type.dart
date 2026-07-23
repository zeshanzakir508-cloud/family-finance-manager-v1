/// Enum representing permission types
enum PermissionType {
  manageFamily,
  deleteFamily,
  transferOwnership,
  inviteMembers,
  removeMembers,
  changeRoles,
  suspendMembers,
  restoreMembers,
  createAccounts,
  editAccounts,
  deleteAccounts,
  manageCategories,
  addTransactions,
  editTransactions,
  deleteTransactions,
  viewReports,
  manageSettings,
  viewActivity,
}

/// Extension methods for PermissionType
extension PermissionTypeExtension on PermissionType {
  /// Get the display name for the permission
  String get displayName {
    switch (this) {
      case PermissionType.manageFamily:
        return 'Manage Family';
      case PermissionType.deleteFamily:
        return 'Delete Family';
      case PermissionType.transferOwnership:
        return 'Transfer Ownership';
      case PermissionType.inviteMembers:
        return 'Invite Members';
      case PermissionType.removeMembers:
        return 'Remove Members';
      case PermissionType.changeRoles:
        return 'Change Roles';
      case PermissionType.suspendMembers:
        return 'Suspend Members';
      case PermissionType.restoreMembers:
        return 'Restore Members';
      case PermissionType.createAccounts:
        return 'Create Accounts';
      case PermissionType.editAccounts:
        return 'Edit Accounts';
      case PermissionType.deleteAccounts:
        return 'Delete Accounts';
      case PermissionType.manageCategories:
        return 'Manage Categories';
      case PermissionType.addTransactions:
        return 'Add Transactions';
      case PermissionType.editTransactions:
        return 'Edit Transactions';
      case PermissionType.deleteTransactions:
        return 'Delete Transactions';
      case PermissionType.viewReports:
        return 'View Reports';
      case PermissionType.manageSettings:
        return 'Manage Settings';
      case PermissionType.viewActivity:
        return 'View Activity';
    }
  }

  /// Get the description for the permission
  String get description {
    switch (this) {
      case PermissionType.manageFamily:
        return 'Manage family settings and information';
      case PermissionType.deleteFamily:
        return 'Delete the entire family';
      case PermissionType.transferOwnership:
        return 'Transfer family ownership to another member';
      case PermissionType.inviteMembers:
        return 'Invite new members to join the family';
      case PermissionType.removeMembers:
        return 'Remove members from the family';
      case PermissionType.changeRoles:
        return 'Change member roles and permissions';
      case PermissionType.suspendMembers:
        return 'Suspend members temporarily';
      case PermissionType.restoreMembers:
        return 'Restore suspended members';
      case PermissionType.createAccounts:
        return 'Create new accounts in the family';
      case PermissionType.editAccounts:
        return 'Edit existing accounts';
      case PermissionType.deleteAccounts:
        return 'Delete accounts';
      case PermissionType.manageCategories:
        return 'Manage expense categories';
      case PermissionType.addTransactions:
        return 'Add new transactions';
      case PermissionType.editTransactions:
        return 'Edit existing transactions';
      case PermissionType.deleteTransactions:
        return 'Delete transactions';
      case PermissionType.viewReports:
        return 'View family reports and analytics';
      case PermissionType.manageSettings:
        return 'Manage family settings';
      case PermissionType.viewActivity:
        return 'View family activity logs';
    }
  }

  /// Get the category of the permission
  String get category {
    switch (this) {
      case PermissionType.manageFamily:
      case PermissionType.deleteFamily:
      case PermissionType.transferOwnership:
        return 'Family Management';
      case PermissionType.inviteMembers:
      case PermissionType.removeMembers:
      case PermissionType.changeRoles:
      case PermissionType.suspendMembers:
      case PermissionType.restoreMembers:
        return 'Member Management';
      case PermissionType.createAccounts:
      case PermissionType.editAccounts:
      case PermissionType.deleteAccounts:
        return 'Account Management';
      case PermissionType.manageCategories:
        return 'Category Management';
      case PermissionType.addTransactions:
      case PermissionType.editTransactions:
      case PermissionType.deleteTransactions:
        return 'Transaction Management';
      case PermissionType.viewReports:
        return 'Reports';
      case PermissionType.manageSettings:
        return 'Settings';
      case PermissionType.viewActivity:
        return 'Activity';
    }
  }

  /// Get the permission string for database
  String get permissionString {
    return name;
  }

  /// Get the permission from string
  static PermissionType fromString(String value) {
    return values.firstWhere(
      (permission) => permission.name == value,
      orElse: () => PermissionType.viewReports,
    );
  }

  /// Get all permissions
  static List<PermissionType> get allPermissions => values;

  /// Get permissions by category
  static List<PermissionType> getByCategory(String category) {
    return values.where((p) => p.category == category).toList();
  }

  /// Get family management permissions
  static List<PermissionType> get familyManagement => 
      values.where((p) => p.category == 'Family Management').toList();

  /// Get member management permissions
  static List<PermissionType> get memberManagement =>
      values.where((p) => p.category == 'Member Management').toList();

  /// Get account management permissions
  static List<PermissionType> get accountManagement =>
      values.where((p) => p.category == 'Account Management').toList();

  /// Get transaction management permissions
  static List<PermissionType> get transactionManagement =>
      values.where((p) => p.category == 'Transaction Management').toList();
}
