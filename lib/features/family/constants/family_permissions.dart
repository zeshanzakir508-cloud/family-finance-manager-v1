/// Permission definitions for the Family feature
class FamilyPermissions {
  // ============ Family Management ============
  /// Permission to manage family settings (name, currency, etc.)
  static const String manageFamily = 'family:manage';
  
  /// Permission to delete the family
  static const String deleteFamily = 'family:delete';
  
  /// Permission to transfer ownership
  static const String transferOwnership = 'family:transfer_ownership';
  
  // ============ Member Management ============
  /// Permission to invite new members
  static const String inviteMembers = 'members:invite';
  
  /// Permission to remove members
  static const String removeMembers = 'members:remove';
  
  /// Permission to change member roles
  static const String changeRoles = 'members:change_roles';
  
  /// Permission to suspend members
  static const String suspendMembers = 'members:suspend';
  
  /// Permission to restore members
  static const String restoreMembers = 'members:restore';
  
  // ============ Account Management ============
  /// Permission to create accounts
  static const String createAccounts = 'accounts:create';
  
  /// Permission to edit accounts
  static const String editAccounts = 'accounts:edit';
  
  /// Permission to delete accounts
  static const String deleteAccounts = 'accounts:delete';
  
  // ============ Category Management ============
  /// Permission to manage categories
  static const String manageCategories = 'categories:manage';
  
  // ============ Transaction Management ============
  /// Permission to add transactions
  static const String addTransactions = 'transactions:add';
  
  /// Permission to edit transactions
  static const String editTransactions = 'transactions:edit';
  
  /// Permission to delete transactions
  static const String deleteTransactions = 'transactions:delete';
  
  // ============ Reports ============
  /// Permission to view reports
  static const String viewReports = 'reports:view';
  
  // ============ Settings ============
  /// Permission to manage settings
  static const String manageSettings = 'settings:manage';
  
  // ============ Activity Logs ============
  /// Permission to view activity logs
  static const String viewActivity = 'activity:view';
  
  // ============ All Permissions ============
  /// All available permissions
  static const List<String> allPermissions = [
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
  ];
  
  /// Owner permissions (all permissions)
  static const List<String> ownerPermissions = allPermissions;
  
  /// Moderator permissions
  static const List<String> moderatorPermissions = [
    inviteMembers,
    removeMembers,
    createAccounts,
    editAccounts,
    manageCategories,
    addTransactions,
    editTransactions,
    viewReports,
    viewActivity,
  ];
  
  /// Member permissions
  static const List<String> memberPermissions = [
    addTransactions,
    editTransactions,
    viewReports,
  ];
  
  /// Viewer permissions (optional, read-only)
  static const List<String> viewerPermissions = [
    viewReports,
  ];
  
  /// Get permissions by role
  static List<String> getPermissionsForRole(String role) {
    switch (role) {
      case 'owner':
        return ownerPermissions;
      case 'moderator':
        return moderatorPermissions;
      case 'member':
        return memberPermissions;
      case 'viewer':
        return viewerPermissions;
      default:
        return [];
    }
  }
  
  /// Check if a role has a specific permission
  static bool hasPermission(String role, String permission) {
    final permissions = getPermissionsForRole(role);
    return permissions.contains(permission);
  }
  
  /// Check if a permission is valid
  static bool isValidPermission(String permission) {
    return allPermissions.contains(permission);
  }
}
