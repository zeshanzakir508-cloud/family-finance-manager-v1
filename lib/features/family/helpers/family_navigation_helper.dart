import '../enums/family_role.dart';

/// Helper class for family navigation logic
class FamilyNavigationHelper {
  /// Route names
  static const String familyHome = '/family';
  static const String createFamily = '/family/create';
  static const String joinFamily = '/family/join';
  static const String familyMembers = '/family/members';
  static const String memberProfile = '/family/member';
  static const String rolesPermissions = '/family/roles';
  static const String inviteMembers = '/family/invite';
  static const String familySettings = '/family/settings';
  static const String transferOwnership = '/family/transfer';
  static const String leaveFamily = '/family/leave';
  static const String deleteFamily = '/family/delete';

  /// Get the route for member profile
  static String getMemberProfileRoute(String memberId) {
    return '$memberProfile/$memberId';
  }

  /// Get the route for inviting members
  static String getInviteMembersRoute(String familyId) {
    return '$inviteMembers?familyId=$familyId';
  }

  /// Check if a route requires family access
  static bool requiresFamilyAccess(String route) {
    final familyRoutes = [
      familyHome,
      familyMembers,
      memberProfile,
      rolesPermissions,
      inviteMembers,
      familySettings,
      transferOwnership,
      leaveFamily,
      deleteFamily,
    ];
    return familyRoutes.any((r) => route.startsWith(r));
  }

  /// Check if a route requires owner permission
  static bool requiresOwnerPermission(String route) {
    final ownerRoutes = [
      transferOwnership,
      deleteFamily,
      rolesPermissions,
    ];
    return ownerRoutes.any((r) => route.startsWith(r));
  }

  /// Check if a route requires moderator permission
  static bool requiresModeratorPermission(String route) {
    final moderatorRoutes = [
      inviteMembers,
      familyMembers,
      rolesPermissions,
    ];
    return moderatorRoutes.any((r) => route.startsWith(r));
  }

  /// Get the family ID from route
  static String? getFamilyIdFromRoute(String route, Map<String, String> params) {
    if (route.startsWith('/family/')) {
      return params['familyId'];
    }
    return null;
  }

  /// Get the member ID from route
  static String? getMemberIdFromRoute(String route) {
    if (route.startsWith(memberProfile)) {
      final parts = route.split('/');
      if (parts.length > 3) {
        return parts[3];
      }
    }
    return null;
  }

  /// Check if a route is accessible to the current user
  static bool isRouteAccessible(
    String route,
    FamilyRole? userRole,
    bool isOwner,
    bool isModerator,
  ) {
    if (!requiresFamilyAccess(route)) return true;
    
    if (requiresOwnerPermission(route)) {
      return isOwner;
    }
    
    if (requiresModeratorPermission(route)) {
      return isOwner || isModerator;
    }
    
    return true;
  }

  /// Get the redirect route for unauthorized access
  static String getUnauthorizedRedirectRoute() {
    return familyHome;
  }

  /// Get the route for going back from a page
  static String getBackRoute(String currentRoute) {
    if (currentRoute == createFamily || currentRoute == joinFamily) {
      return familyHome;
    }
    if (currentRoute == inviteMembers) {
      return familyMembers;
    }
    if (currentRoute == familySettings) {
      return familyHome;
    }
    return familyHome;
  }

  /// Get navigation breadcrumbs for a route
  static List<Map<String, String>> getBreadcrumbs(String route) {
    final breadcrumbs = <Map<String, String>>[
      {'name': 'Home', 'route': familyHome},
    ];

    if (route.startsWith(createFamily)) {
      breadcrumbs.add({'name': 'Create Family', 'route': createFamily});
    } else if (route.startsWith(joinFamily)) {
      breadcrumbs.add({'name': 'Join Family', 'route': joinFamily});
    } else if (route.startsWith(familyMembers)) {
      breadcrumbs.add({'name': 'Members', 'route': familyMembers});
    } else if (route.startsWith(memberProfile)) {
      breadcrumbs.add({'name': 'Members', 'route': familyMembers});
      breadcrumbs.add({'name': 'Profile', 'route': route});
    } else if (route.startsWith(rolesPermissions)) {
      breadcrumbs.add({'name': 'Roles', 'route': rolesPermissions});
    } else if (route.startsWith(inviteMembers)) {
      breadcrumbs.add({'name': 'Invite', 'route': inviteMembers});
    } else if (route.startsWith(familySettings)) {
      breadcrumbs.add({'name': 'Settings', 'route': familySettings});
    }

    return breadcrumbs;
  }
}
