import '../enums/family_role.dart';
import '../enums/permission_type.dart';
import '../constants/family_permissions.dart';

/// Helper class for permission operations
class PermissionHelper {
  /// Get all permissions for a role
  static List<PermissionType> getPermissionsForRole(FamilyRole role) {
    switch (role) {
      case FamilyRole.owner:
        return PermissionType.allPermissions;
      case FamilyRole.moderator:
        return [
          PermissionType.inviteMembers,
          PermissionType.removeMembers,
          PermissionType.createAccounts,
          PermissionType.editAccounts,
          PermissionType.manageCategories,
          PermissionType.addTransactions,
          PermissionType.editTransactions,
          PermissionType.viewReports,
          PermissionType.viewActivity,
        ];
      case FamilyRole.member:
        return [
          PermissionType.addTransactions,
          PermissionType.editTransactions,
          PermissionType.viewReports,
        ];
      case FamilyRole.viewer:
        return [
          PermissionType.viewReports,
        ];
    }
  }

  /// Check if a role has a specific permission
  static bool hasPermission(FamilyRole role, PermissionType permission) {
    final permissions = getPermissionsForRole(role);
    return permissions.contains(permission);
  }

  /// Check if a role has any of the given permissions
  static bool hasAnyPermission(FamilyRole role, List<PermissionType> permissions) {
    final rolePermissions = getPermissionsForRole(role);
    return permissions.any((p) => rolePermissions.contains(p));
  }

  /// Check if a role has all of the given permissions
  static bool hasAllPermissions(FamilyRole role, List<PermissionType> permissions) {
    final rolePermissions = getPermissionsForRole(role);
    return permissions.every((p) => rolePermissions.contains(p));
  }

  /// Get permission descriptions
  static Map<PermissionType, String> getPermissionDescriptions() {
    return {
      PermissionType.manageFamily: 'Manage family settings and information',
      PermissionType.deleteFamily: 'Delete the entire family',
      PermissionType.transferOwnership: 'Transfer family ownership to another member',
      PermissionType.inviteMembers: 'Invite new members to join the family',
      PermissionType.removeMembers: 'Remove members from the family',
      PermissionType.changeRoles: 'Change member roles and permissions',
      PermissionType.suspendMembers: 'Suspend members temporarily',
      PermissionType.restoreMembers: 'Restore suspended members',
      PermissionType.createAccounts: 'Create new accounts in the family',
      PermissionType.editAccounts: 'Edit existing accounts',
      PermissionType.deleteAccounts: 'Delete accounts',
      PermissionType.manageCategories: 'Manage expense categories',
      PermissionType.addTransactions: 'Add new transactions',
      PermissionType.editTransactions: 'Edit existing transactions',
      PermissionType.deleteTransactions: 'Delete transactions',
      PermissionType.viewReports: 'View family reports and analytics',
      PermissionType.manageSettings: 'Manage family settings',
      PermissionType.viewActivity: 'View family activity logs',
    };
  }

  /// Get permission categories
  static Map<String, List<PermissionType>> getPermissionCategories() {
    return {
      'Family Management': [
        PermissionType.manageFamily,
        PermissionType.deleteFamily,
        PermissionType.transferOwnership,
      ],
      'Member Management': [
        PermissionType.inviteMembers,
        PermissionType.removeMembers,
        PermissionType.changeRoles,
        PermissionType.suspendMembers,
        PermissionType.restoreMembers,
      ],
      'Account Management': [
        PermissionType.createAccounts,
        PermissionType.editAccounts,
        PermissionType.deleteAccounts,
      ],
      'Transaction Management': [
        PermissionType.addTransactions,
        PermissionType.editTransactions,
        PermissionType.deleteTransactions,
      ],
      'Other': [
        PermissionType.manageCategories,
        PermissionType.viewReports,
        PermissionType.manageSettings,
        PermissionType.viewActivity,
      ],
    };
  }

  /// Get permission icon for a permission type
  static String getPermissionIcon(PermissionType permission) {
    switch (permission) {
      case PermissionType.manageFamily:
        return 'settings';
      case PermissionType.deleteFamily:
        return 'delete';
      case PermissionType.transferOwnership:
        return 'swap_horiz';
      case PermissionType.inviteMembers:
        return 'person_add';
      case PermissionType.removeMembers:
        return 'person_remove';
      case PermissionType.changeRoles:
        return 'admin_panel_settings';
      case PermissionType.suspendMembers:
        return 'pause_circle';
      case PermissionType.restoreMembers:
        return 'restore';
      case PermissionType.createAccounts:
        return 'account_balance_wallet';
      case PermissionType.editAccounts:
        return 'edit';
      case PermissionType.deleteAccounts:
        return 'delete_outline';
      case PermissionType.manageCategories:
        return 'category';
      case PermissionType.addTransactions:
        return 'add_circle';
      case PermissionType.editTransactions:
        return 'edit_note';
      case PermissionType.deleteTransactions:
        return 'delete_sweep';
      case PermissionType.viewReports:
        return 'bar_chart';
      case PermissionType.manageSettings:
        return 'settings_applications';
      case PermissionType.viewActivity:
        return 'history';
    }
  }

  /// Check if a permission is an admin-only permission
  static bool isAdminPermission(PermissionType permission) {
    final adminPermissions = [
      PermissionType.deleteFamily,
      PermissionType.transferOwnership,
      PermissionType.changeRoles,
    ];
    return adminPermissions.contains(permission);
  }

  /// Check if a permission is a moderator permission
  static bool isModeratorPermission(PermissionType permission) {
    final moderatorPermissions = [
      PermissionType.inviteMembers,
      PermissionType.removeMembers,
      PermissionType.suspendMembers,
      PermissionType.restoreMembers,
    ];
    return moderatorPermissions.contains(permission);
  }

  /// Get permission level (admin, moderator, member, viewer)
  static String getPermissionLevel(PermissionType permission) {
    if (isAdminPermission(permission)) return 'admin';
    if (isModeratorPermission(permission)) return 'moderator';
    return 'member';
  }

  /// Format permission for display
  static String formatPermissionName(PermissionType permission) {
    return permission.displayName;
  }

  /// Format permission for display with category
  static String formatPermissionWithCategory(PermissionType permission) {
    return '${permission.category} › ${permission.displayName}';
  }

  /// Get permission summary for a role
  static Map<String, dynamic> getPermissionSummaryForRole(FamilyRole role) {
    final permissions = getPermissionsForRole(role);
    final byCategory = <String, List<String>>{};
    
    for (final permission in permissions) {
      final category = permission.category;
      byCategory.putIfAbsent(category, () => []);
      byCategory[category]!.add(permission.displayName);
    }

    return {
      'role': role.displayName,
      'count': permissions.length,
      'categories': byCategory,
      'permissions': permissions.map((p) => p.displayName).toList(),
    };
  }
}
