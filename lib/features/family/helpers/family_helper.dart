import '../enums/family_role.dart';
import '../enums/member_status.dart';
import '../constants/family_constants.dart';

/// Utility helper class for family operations
class FamilyHelper {
  /// Generate a random invitation code
  static String generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().microsecondsSinceEpoch;
    var code = '';
    for (var i = 0; i < 6; i++) {
      final index = (random + i * 7) % chars.length;
      code += chars[index];
    }
    return code;
  }

  /// Format member count display
  static String formatMemberCount(int count) {
    if (count == 0) return 'No members';
    if (count == 1) return '1 member';
    return '$count members';
  }

  /// Get role display name with emoji
  static String getRoleDisplayWithEmoji(FamilyRole role) {
    switch (role) {
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

  /// Get member status display with emoji
  static String getStatusDisplayWithEmoji(MemberStatus status) {
    switch (status) {
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

  /// Get member status color
  static String getStatusColorHex(MemberStatus status) {
    switch (status) {
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

  /// Get role color
  static String getRoleColorHex(FamilyRole role) {
    switch (role) {
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

  /// Check if family is full
  static bool isFamilyFull(int memberCount) {
    return memberCount >= FamilyConstants.maxMembersPerFamily;
  }

  /// Get remaining member slots
  static int getRemainingSlots(int memberCount) {
    return FamilyConstants.maxMembersPerFamily - memberCount;
  }

  /// Get family statistics description
  static String getFamilyStatisticsDescription(Map<String, dynamic> stats) {
    final total = stats['total'] ?? 0;
    final active = stats['active'] ?? 0;
    final pending = stats['pending'] ?? 0;
    
    if (total == 0) return 'No members yet';
    if (active == total) return '$total active members';
    return '$active active, $pending pending';
  }

  /// Get invitation status description
  static String getInvitationStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return 'Awaiting response';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Declined';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Get time remaining for invitation
  static String getInvitationTimeRemaining(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);
    
    if (difference.isNegative) return 'Expired';
    
    final days = difference.inDays;
    if (days > 0) return '$days days remaining';
    
    final hours = difference.inHours;
    if (hours > 0) return '$hours hours remaining';
    
    final minutes = difference.inMinutes;
    if (minutes > 0) return '$minutes minutes remaining';
    
    return 'Expires soon';
  }

  /// Get member initials
  static String getMemberInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  /// Get random avatar color
  static String getRandomAvatarColor(String seed) {
    final colors = FamilyConstants.avatarColors;
    final index = seed.hashCode.abs() % colors.length;
    return colors[index];
  }

  /// Sort members by role priority
  static List<MemberModel> sortMembersByRole(List<MemberModel> members) {
    final sorted = List<MemberModel>.from(members);
    sorted.sort((a, b) {
      // Owner first
      if (a.role == FamilyRole.owner) return -1;
      if (b.role == FamilyRole.owner) return 1;
      // Then moderators
      if (a.role == FamilyRole.moderator && b.role != FamilyRole.moderator) return -1;
      if (b.role == FamilyRole.moderator && a.role != FamilyRole.moderator) return 1;
      // Then by status (active first)
      if (a.status == MemberStatus.active && b.status != MemberStatus.active) return -1;
      if (b.status == MemberStatus.active && a.status != MemberStatus.active) return 1;
      // Then by name
      return a.name.compareTo(b.name);
    });
    return sorted;
  }

  /// Filter members by role
  static List<MemberModel> filterMembersByRole(List<MemberModel> members, FamilyRole role) {
    return members.where((m) => m.role == role).toList();
  }

  /// Filter members by status
  static List<MemberModel> filterMembersByStatus(List<MemberModel> members, MemberStatus status) {
    return members.where((m) => m.status == status).toList();
  }

  /// Get member display name
  static String getMemberDisplayName(MemberModel member) {
    return member.name ?? member.email ?? 'Unknown Member';
  }

  /// Check if a member is a moderator or above
  static bool isModeratorOrAbove(FamilyRole role) {
    return role == FamilyRole.owner || role == FamilyRole.moderator;
  }

  /// Check if a member is an admin (owner only)
  static bool isAdmin(FamilyRole role) {
    return role == FamilyRole.owner;
  }

  /// Check if member can be managed
  static bool canBeManaged(MemberModel member, FamilyRole currentUserRole) {
    if (member.role == FamilyRole.owner) return false;
    if (currentUserRole == FamilyRole.owner) return true;
    if (currentUserRole == FamilyRole.moderator) {
      return member.role != FamilyRole.owner && member.role != FamilyRole.moderator;
    }
    return false;
  }

  /// Get member role priority
  static int getRolePriority(FamilyRole role) {
    return role.priority;
  }

  /// Check if a member can perform an action on another member
  static bool canPerformActionOnMember(
    MemberModel actor,
    MemberModel target,
    String action,
  ) {
    // Cannot act on self
    if (actor.id == target.id) return false;
    
    // Owner can do anything
    if (actor.role == FamilyRole.owner) return true;
    
    // Cannot act on owner
    if (target.role == FamilyRole.owner) return false;
    
    // Moderator can act on members and viewers
    if (actor.role == FamilyRole.moderator) {
      return target.role == FamilyRole.member || 
             target.role == FamilyRole.viewer;
    }
    
    return false;
  }
}
