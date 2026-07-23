import 'package:flutter/material.dart';
import '../enums/family_role.dart';
import '../enums/member_status.dart';
import '../enums/permission_type.dart';
import '../models/family_invitation_model.dart';

/// Extension methods for FamilyRole
extension FamilyRoleExtensions on FamilyRole {
  /// Get display name with emoji
  String get displayWithEmoji {
    switch (this) {
      case FamilyRole.owner:
        return '👑 Owner';
      case FamilyRole.moderator:
        return '🛡️ Moderator';
      case FamilyRole.member:
        return '👤 Member';
      case FamilyRole.viewer:
        return '👁️ Viewer';
    }
  }

  /// Get color for the role
  Color get color {
    switch (this) {
      case FamilyRole.owner:
        return Colors.red;
      case FamilyRole.moderator:
        return Colors.teal;
      case FamilyRole.member:
        return Colors.blue;
      case FamilyRole.viewer:
        return Colors.green;
    }
  }

  /// Get light color for the role (for backgrounds)
  Color get lightColor {
    return color.withOpacity(0.1);
  }

  /// Get icon for the role
  IconData get icon {
    switch (this) {
      case FamilyRole.owner:
        return Icons.crown;
      case FamilyRole.moderator:
        return Icons.shield;
      case FamilyRole.member:
        return Icons.person;
      case FamilyRole.viewer:
        return Icons.visibility;
    }
  }

  /// Get priority level
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

  /// Check if this role is higher than another
  bool isHigherThan(FamilyRole other) {
    return priority > other.priority;
  }

  /// Check if this role is lower than another
  bool isLowerThan(FamilyRole other) {
    return priority < other.priority;
  }

  /// Check if this role is at least as high as another
  bool isAtLeast(FamilyRole other) {
    return priority >= other.priority;
  }

  /// Check if this role is an admin role
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

  /// Check if this role can delete family
  bool get canDeleteFamily {
    return this == FamilyRole.owner;
  }

  /// Get badge widget for the role
  Widget get badge {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        displayName,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Get all roles as a list
  static List<FamilyRole> get all => values;

  /// Get admin roles
  static List<FamilyRole> get adminRoles =>
      values.where((role) => role.isAdmin).toList();

  /// Get non-admin roles
  static List<FamilyRole> get nonAdminRoles =>
      values.where((role) => !role.isAdmin).toList();

  /// Parse role from string
  static FamilyRole fromString(String value) {
    return values.firstWhere(
      (role) => role.name.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyRole.member,
    );
  }
}

/// Extension methods for MemberStatus
extension MemberStatusExtensions on MemberStatus {
  /// Get display name with emoji
  String get displayWithEmoji {
    switch (this) {
      case MemberStatus.active:
        return '✅ Active';
      case MemberStatus.pending:
        return '⏳ Pending';
      case MemberStatus.suspended:
        return '⛔ Suspended';
      case MemberStatus.blocked:
        return '🚫 Blocked';
      case MemberStatus.removed:
        return '❌ Removed';
      case MemberStatus.left:
        return '🚪 Left';
    }
  }

  /// Get color for the status
  Color get color {
    switch (this) {
      case MemberStatus.active:
        return Colors.green;
      case MemberStatus.pending:
        return Colors.orange;
      case MemberStatus.suspended:
        return Colors.deepOrange;
      case MemberStatus.blocked:
        return Colors.red;
      case MemberStatus.removed:
        return Colors.grey;
      case MemberStatus.left:
        return Colors.grey;
    }
  }

  /// Get light color for the status
  Color get lightColor {
    return color.withOpacity(0.1);
  }

  /// Get icon for the status
  IconData get icon {
    switch (this) {
      case MemberStatus.active:
        return Icons.check_circle;
      case MemberStatus.pending:
        return Icons.hourglass_empty;
      case MemberStatus.suspended:
        return Icons.pause_circle;
      case MemberStatus.blocked:
        return Icons.block;
      case MemberStatus.removed:
        return Icons.remove_circle;
      case MemberStatus.left:
        return Icons.exit_to_app;
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
    return this == MemberStatus.suspended || this == MemberStatus.blocked;
  }

  /// Check if the member can be removed
  bool get canBeRemoved {
    return this == MemberStatus.active ||
           this == MemberStatus.suspended ||
           this == MemberStatus.pending;
  }

  /// Get badge widget for the status
  Widget get badge {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        displayName,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Get all statuses
  static List<MemberStatus> get all => values;

  /// Get active statuses
  static List<MemberStatus> get activeStatuses =>
      values.where((status) => status.canAccess).toList();

  /// Get terminal statuses
  static List<MemberStatus> get terminalStatuses =>
      values.where((status) => status.isTerminal).toList();

  /// Parse status from string
  static MemberStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MemberStatus.active,
    );
  }
}

/// Extension methods for PermissionType
extension PermissionTypeExtensions on PermissionType {
  /// Get display name
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

  /// Get category
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

  /// Get icon
  IconData get icon {
    switch (this) {
      case PermissionType.manageFamily:
        return Icons.settings;
      case PermissionType.deleteFamily:
        return Icons.delete;
      case PermissionType.transferOwnership:
        return Icons.swap_horiz;
      case PermissionType.inviteMembers:
        return Icons.person_add;
      case PermissionType.removeMembers:
        return Icons.person_remove;
      case PermissionType.changeRoles:
        return Icons.admin_panel_settings;
      case PermissionType.suspendMembers:
        return Icons.pause_circle;
      case PermissionType.restoreMembers:
        return Icons.restore;
      case PermissionType.createAccounts:
        return Icons.account_balance_wallet;
      case PermissionType.editAccounts:
        return Icons.edit;
      case PermissionType.deleteAccounts:
        return Icons.delete_outline;
      case PermissionType.manageCategories:
        return Icons.category;
      case PermissionType.addTransactions:
        return Icons.add_circle;
      case PermissionType.editTransactions:
        return Icons.edit_note;
      case PermissionType.deleteTransactions:
        return Icons.delete_sweep;
      case PermissionType.viewReports:
        return Icons.bar_chart;
      case PermissionType.manageSettings:
        return Icons.settings_applications;
      case PermissionType.viewActivity:
        return Icons.history;
    }
  }

  /// Check if this is an admin permission
  bool get isAdminPermission {
    final adminPermissions = [
      PermissionType.deleteFamily,
      PermissionType.transferOwnership,
      PermissionType.changeRoles,
    ];
    return adminPermissions.contains(this);
  }

  /// Check if this is a moderator permission
  bool get isModeratorPermission {
    final moderatorPermissions = [
      PermissionType.inviteMembers,
      PermissionType.removeMembers,
      PermissionType.suspendMembers,
      PermissionType.restoreMembers,
    ];
    return moderatorPermissions.contains(this);
  }

  /// Get permission level
  String get level {
    if (isAdminPermission) return 'admin';
    if (isModeratorPermission) return 'moderator';
    return 'member';
  }

  /// Parse from string
  static PermissionType fromString(String value) {
    return values.firstWhere(
      (permission) => permission.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PermissionType.viewReports,
    );
  }
}

/// Extension methods for FamilyInvitationModel
extension FamilyInvitationExtensions on FamilyInvitationModel {
  /// Get status display with emoji
  String get statusDisplayWithEmoji {
    return status.displayWithEmoji;
  }

  /// Check if the invitation is active
  bool get isActive {
    return status == InviteStatus.pending && !isExpired;
  }

  /// Get time remaining before expiry
  String get timeRemaining {
    if (isExpired) return 'Expired';
    final difference = expiresAt.difference(DateTime.now());
    final days = difference.inDays;
    if (days > 0) return '$days days remaining';
    final hours = difference.inHours;
    if (hours > 0) return '$hours hours remaining';
    final minutes = difference.inMinutes;
    if (minutes > 0) return '$minutes minutes remaining';
    return 'Expires soon';
  }

  /// Get the invitation code formatted with dashes
  String get formattedCode {
    if (code.length != 6) return code;
    return '${code.substring(0, 3)}-${code.substring(3)}';
  }

  /// Get contact display
  String get contactDisplay {
    if (email != null && email!.isNotEmpty) return email!;
    if (phone != null && phone!.isNotEmpty) return phone!;
    return 'No contact';
  }

  /// Get display name
  String get displayName {
    return name ?? contactDisplay;
  }
}

/// Extension methods for List<MemberModel>
extension MemberListExtensions on List<MemberModel> {
  /// Get active members
  List<MemberModel> get activeMembers =>
      where((m) => m.status == MemberStatus.active).toList();

  /// Get pending members
  List<MemberModel> get pendingMembers =>
      where((m) => m.status == MemberStatus.pending).toList();

  /// Get suspended members
  List<MemberModel> get suspendedMembers =>
      where((m) => m.status == MemberStatus.suspended).toList();

  /// Get members by role
  List<MemberModel> byRole(FamilyRole role) =>
      where((m) => m.role == role).toList();

  /// Get owner
  MemberModel? get owner => firstWhereOrNull((m) => m.role == FamilyRole.owner);

  /// Get moderators
  List<MemberModel> get moderators => byRole(FamilyRole.moderator);

  /// Get admin members (owner + moderators)
  List<MemberModel> get adminMembers =>
      where((m) => m.role.isAdmin).toList();

  /// Sort by role priority
  List<MemberModel> sortedByRole() {
    final sorted = List<MemberModel>.from(this);
    sorted.sort((a, b) => b.role.priority.compareTo(a.role.priority));
    return sorted;
  }

  /// Search members by name or email
  List<MemberModel> search(String query) {
    if (query.isEmpty) return this;
    final lowerQuery = query.toLowerCase();
    return where((m) {
      final name = m.name?.toLowerCase() ?? '';
      final email = m.email?.toLowerCase() ?? '';
      return name.contains(lowerQuery) || email.contains(lowerQuery);
    }).toList();
  }

  /// Get member count by role
  Map<FamilyRole, int> get countByRole {
    final map = <FamilyRole, int>{};
    for (final role in FamilyRole.values) {
      map[role] = byRole(role).length;
    }
    return map;
  }

  /// Get member count by status
  Map<MemberStatus, int> get countByStatus {
    final map = <MemberStatus, int>{};
    for (final status in MemberStatus.values) {
      map[status] = where((m) => m.status == status).length;
    }
    return map;
  }

  /// Get member summaries
  List<Map<String, dynamic>> get summaries =>
      map((m) => m.toSummary()).toList();
}

/// Extension methods for List<FamilyInvitationModel>
extension InvitationListExtensions on List<FamilyInvitationModel> {
  /// Get active invitations
  List<FamilyInvitationModel> get activeInvitations =>
      where((i) => i.isActive).toList();

  /// Get pending invitations
  List<FamilyInvitationModel> get pendingInvitations =>
      where((i) => i.status == InviteStatus.pending).toList();

  /// Get expired invitations
  List<FamilyInvitationModel> get expiredInvitations =>
      where((i) => i.isExpired).toList();

  /// Get accepted invitations
  List<FamilyInvitationModel> get acceptedInvitations =>
      where((i) => i.status == InviteStatus.accepted).toList();

  /// Get invitations by email
  List<FamilyInvitationModel> byEmail(String email) =>
      where((i) => i.email == email).toList();

  /// Sort by creation date (newest first)
  List<FamilyInvitationModel> sortedByNewest() {
    final sorted = List<FamilyInvitationModel>.from(this);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Get invitation count by status
  Map<InviteStatus, int> get countByStatus {
    final map = <InviteStatus, int>{};
    for (final status in InviteStatus.values) {
      map[status] = where((i) => i.status == status).length;
    }
    return map;
  }

  /// Get active invitation count
  int get activeCount => activeInvitations.length;

  /// Get pending count
  int get pendingCount => pendingInvitations.length;

  /// Get expired count
  int get expiredCount => expiredInvitations.length;

  /// Get accepted count
  int get acceptedCount => acceptedInvitations.length;
}
