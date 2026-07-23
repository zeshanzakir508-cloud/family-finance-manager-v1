import '../enums/family_role.dart';
import '../enums/member_status.dart';

/// Helper class for member operations
class MemberHelper {
  /// Get member avatar color based on name
  static String getMemberColor(String name) {
    final colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4',
      '#FF9F43', '#A29BFE', '#FD79A8', '#00CEC9',
      '#FDCB6E', '#6C5CE7', '#00B894', '#E17055'
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  /// Get member initials
  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
  }

  /// Get member display name
  static String getDisplayName(MemberModel member) {
    return member.name ?? member.email ?? 'Unknown Member';
  }

  /// Get member status description
  static String getStatusDescription(MemberStatus status) {
    switch (status) {
      case MemberStatus.active:
        return 'Active member';
      case MemberStatus.pending:
        return 'Waiting for confirmation';
      case MemberStatus.suspended:
        return 'Temporarily suspended';
      case MemberStatus.blocked:
        return 'Blocked from family';
      case MemberStatus.removed:
        return 'Removed from family';
      case MemberStatus.left:
        return 'Left the family';
    }
  }

  /// Check if a member can perform an action
  static bool canPerformAction(MemberModel member, String action) {
    if (member.status != MemberStatus.active) return false;
    
    switch (action) {
      case 'add_transaction':
        return member.role != FamilyRole.viewer;
      case 'edit_transaction':
        return member.role != FamilyRole.viewer;
      case 'delete_transaction':
        return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
      case 'view_report':
        return true;
      case 'manage_account':
        return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
      case 'manage_category':
        return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
      case 'invite_member':
        return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
      case 'remove_member':
        return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
      case 'change_role':
        return member.role == FamilyRole.owner;
      default:
        return false;
    }
  }

  /// Get member actions based on role and status
  static List<String> getAvailableActions(MemberModel member) {
    final actions = <String>[];
    
    if (member.status != MemberStatus.active) return actions;
    
    actions.add('view_profile');
    
    switch (member.role) {
      case FamilyRole.owner:
        actions.addAll(['manage_family', 'manage_members', 'manage_roles']);
        break;
      case FamilyRole.moderator:
        actions.addAll(['manage_members', 'manage_content']);
        break;
      case FamilyRole.member:
        actions.addAll(['add_transaction', 'view_reports']);
        break;
      case FamilyRole.viewer:
        actions.add('view_reports');
        break;
    }
    
    return actions;
  }

  /// Check if a member can be managed by another member
  static bool canBeManaged(MemberModel manager, MemberModel target) {
    if (manager.id == target.id) return false;
    if (manager.status != MemberStatus.active) return false;
    if (target.status != MemberStatus.active && target.status != MemberStatus.suspended) return false;
    
    // Owner can manage everyone
    if (manager.role == FamilyRole.owner) return true;
    
    // Cannot manage owner
    if (target.role == FamilyRole.owner) return false;
    
    // Moderator can manage members and viewers
    if (manager.role == FamilyRole.moderator) {
      return target.role == FamilyRole.member || target.role == FamilyRole.viewer;
    }
    
    return false;
  }

  /// Get role priority
  static int getRolePriority(FamilyRole role) {
    return role.priority;
  }

  /// Sort members by role priority
  static List<MemberModel> sortByRolePriority(List<MemberModel> members) {
    final sorted = List<MemberModel>.from(members);
    sorted.sort((a, b) => getRolePriority(b.role).compareTo(getRolePriority(a.role)));
    return sorted;
  }

  /// Filter members by role
  static List<MemberModel> filterByRole(List<MemberModel> members, FamilyRole role) {
    return members.where((m) => m.role == role).toList();
  }

  /// Filter members by status
  static List<MemberModel> filterByStatus(List<MemberModel> members, MemberStatus status) {
    return members.where((m) => m.status == status).toList();
  }

  /// Get active members only
  static List<MemberModel> getActiveMembers(List<MemberModel> members) {
    return members.where((m) => m.status == MemberStatus.active).toList();
  }

  /// Search members by name or email
  static List<MemberModel> searchMembers(List<MemberModel> members, String query) {
    if (query.isEmpty) return members;
    final lowerQuery = query.toLowerCase();
    return members.where((m) {
      final name = m.name?.toLowerCase() ?? '';
      final email = m.email?.toLowerCase() ?? '';
      return name.contains(lowerQuery) || email.contains(lowerQuery);
    }).toList();
  }

  /// Get member summary
  static Map<String, dynamic> getMemberSummary(MemberModel member) {
    return {
      'id': member.id,
      'name': getDisplayName(member),
      'role': member.role.displayName,
      'status': member.status.displayName,
      'email': member.email,
      'joinedAt': member.joinedAt?.toIso8601String(),
    };
  }

  /// Check if member is an admin (owner or moderator)
  static bool isAdmin(MemberModel member) {
    return member.role == FamilyRole.owner || member.role == FamilyRole.moderator;
  }

  /// Check if member is an owner
  static bool isOwner(MemberModel member) {
    return member.role == FamilyRole.owner;
  }

  /// Check if member is a moderator
  static bool isModerator(MemberModel member) {
    return member.role == FamilyRole.moderator;
  }
}
