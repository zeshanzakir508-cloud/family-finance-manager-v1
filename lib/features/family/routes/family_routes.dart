import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/pages/family_home_page.dart';
import '../views/pages/create_family_page.dart';
import '../views/pages/join_family_page.dart';
import '../views/pages/family_members_page.dart';
import '../views/pages/member_profile_page.dart';
import '../views/pages/roles_permissions_page.dart';
import '../views/pages/invite_members_page.dart';
import '../views/pages/family_settings_page.dart';
import '../views/pages/ownership_transfer_page.dart';
import '../views/pages/leave_family_page.dart';
import '../views/pages/delete_family_page.dart';
import '../enums/family_role.dart';
import '../providers/family_provider.dart';
import '../helpers/family_navigation_helper.dart';

/// Route names for the family feature
class FamilyRoutes {
  static const String home = '/family';
  static const String create = '/family/create';
  static const String join = '/family/join';
  static const String members = '/family/members';
  static const String memberProfile = '/family/member';
  static const String rolesPermissions = '/family/roles';
  static const String inviteMembers = '/family/invite';
  static const String settings = '/family/settings';
  static const String transferOwnership = '/family/transfer';
  static const String leave = '/family/leave';
  static const String delete = '/family/delete';

  /// Get all routes
  static List<String> get allRoutes => [
        home,
        create,
        join,
        members,
        memberProfile,
        rolesPermissions,
        inviteMembers,
        settings,
        transferOwnership,
        leave,
        delete,
      ];

  /// Check if a route is a family route
  static bool isFamilyRoute(String route) {
    return route.startsWith('/family');
  }

  /// Get the route for member profile
  static String getMemberProfileRoute(String memberId) {
    return '$memberProfile/$memberId';
  }

  /// Get the route for inviting members
  static String getInviteMembersRoute(String familyId) {
    return '$inviteMembers?familyId=$familyId';
  }

  /// Check if a route requires family selection
  static bool requiresFamilySelection(String route) {
    return route != home && route != create && route != join;
  }

  /// Check if a route requires owner permission
  static bool requiresOwnerPermission(String route) {
    final ownerRoutes = [
      transferOwnership,
      delete,
      rolesPermissions,
    ];
    return ownerRoutes.any((r) => route.startsWith(r));
  }

  /// Check if a route requires moderator permission
  static bool requiresModeratorPermission(String route) {
    final moderatorRoutes = [
      inviteMembers,
      members,
      rolesPermissions,
    ];
    return moderatorRoutes.any((r) => route.startsWith(r));
  }
}

/// Route configuration for family feature
class FamilyRouteConfig {
  /// Get the route settings
  static RouteSettings getRouteSettings(String route, {Map<String, dynamic>? arguments}) {
    return RouteSettings(
      name: route,
      arguments: arguments,
    );
  }

  /// Build a route for family
  static Widget buildRoute(BuildContext context, RouteSettings settings) {
    final routeName = settings.name ?? '';
    final arguments = settings.arguments as Map<String, dynamic>?;

    // Extract memberId from route path
    String? memberId;
    if (routeName.startsWith(FamilyRoutes.memberProfile)) {
      final parts = routeName.split('/');
      if (parts.length > 3) {
        memberId = parts[3];
      }
    }

    // Extract familyId from query parameters
    String? familyId;
    if (arguments != null && arguments.containsKey('familyId')) {
      familyId = arguments['familyId'] as String?;
    }

    // Extract memberId from arguments
    if (memberId == null && arguments != null && arguments.containsKey('memberId')) {
      memberId = arguments['memberId'] as String?;
    }

    switch (routeName) {
      case FamilyRoutes.home:
        return const FamilyHomePage();
      case FamilyRoutes.create:
        return const CreateFamilyPage();
      case FamilyRoutes.join:
        return const JoinFamilyPage();
      case FamilyRoutes.members:
        return const FamilyMembersPage();
      case FamilyRoutes.memberProfile:
        return MemberProfilePage(memberId: memberId ?? '');
      case FamilyRoutes.rolesPermissions:
        return const RolesPermissionsPage();
      case FamilyRoutes.inviteMembers:
        return InviteMembersPage(familyId: familyId);
      case FamilyRoutes.settings:
        return const FamilySettingsPage();
      case FamilyRoutes.transferOwnership:
        return const OwnershipTransferPage();
      case FamilyRoutes.leave:
        return const LeaveFamilyPage();
      case FamilyRoutes.delete:
        return const DeleteFamilyPage();
      default:
        return const FamilyHomePage();
    }
  }

  /// Get the page route for a family route
  static PageRoute getPageRoute(String route, {Map<String, dynamic>? arguments}) {
    return MaterialPageRoute(
      builder: (context) => buildRoute(context, RouteSettings(name: route, arguments: arguments)),
      settings: RouteSettings(name: route),
    );
  }

  /// Get the route table for GoRouter
  static Map<String, WidgetBuilder> get routeTable {
    return {
      FamilyRoutes.home: (context) => const FamilyHomePage(),
      FamilyRoutes.create: (context) => const CreateFamilyPage(),
      FamilyRoutes.join: (context) => const JoinFamilyPage(),
      FamilyRoutes.members: (context) => const FamilyMembersPage(),
      FamilyRoutes.memberProfile: (context) => const MemberProfilePage(),
      FamilyRoutes.rolesPermissions: (context) => const RolesPermissionsPage(),
      FamilyRoutes.inviteMembers: (context) => const InviteMembersPage(),
      FamilyRoutes.settings: (context) => const FamilySettingsPage(),
      FamilyRoutes.transferOwnership: (context) => const OwnershipTransferPage(),
      FamilyRoutes.leave: (context) => const LeaveFamilyPage(),
      FamilyRoutes.delete: (context) => const DeleteFamilyPage(),
    };
  }
}

/// Extension for GoRouter navigation context
extension FamilyRouteContext on BuildContext {
  /// Navigate to family home
  void goToFamilyHome() {
    Navigator.pushReplacementNamed(this, FamilyRoutes.home);
  }

  /// Navigate to create family
  void goToCreateFamily() {
    Navigator.pushNamed(this, FamilyRoutes.create);
  }

  /// Navigate to join family
  void goToJoinFamily() {
    Navigator.pushNamed(this, FamilyRoutes.join);
  }

  /// Navigate to family members
  void goToFamilyMembers() {
    Navigator.pushNamed(this, FamilyRoutes.members);
  }

  /// Navigate to member profile
  void goToMemberProfile(String memberId) {
    Navigator.pushNamed(this, FamilyRoutes.getMemberProfileRoute(memberId));
  }

  /// Navigate to roles and permissions
  void goToRolesPermissions() {
    Navigator.pushNamed(this, FamilyRoutes.rolesPermissions);
  }

  /// Navigate to invite members
  void goToInviteMembers({String? familyId}) {
    if (familyId != null) {
      Navigator.pushNamed(
        this,
        FamilyRoutes.inviteMembers,
        arguments: {'familyId': familyId},
      );
    } else {
      Navigator.pushNamed(this, FamilyRoutes.inviteMembers);
    }
  }

  /// Navigate to family settings
  void goToFamilySettings() {
    Navigator.pushNamed(this, FamilyRoutes.settings);
  }

  /// Navigate to transfer ownership
  void goToTransferOwnership() {
    Navigator.pushNamed(this, FamilyRoutes.transferOwnership);
  }

  /// Navigate to leave family
  void goToLeaveFamily() {
    Navigator.pushNamed(this, FamilyRoutes.leave);
  }

  /// Navigate to delete family
  void goToDeleteFamily() {
    Navigator.pushNamed(this, FamilyRoutes.delete);
  }

  /// Navigate back to family home
  void popToFamilyHome() {
    Navigator.popUntil(this, (route) => route.settings.name == FamilyRoutes.home);
  }
}

/// Provider for family routes
final familyRouteProvider = Provider<FamilyRouteConfig>((ref) {
  return FamilyRouteConfig();
});

/// Provider for checking if current route is a family route
final isFamilyRouteProvider = Provider<bool>((ref) {
  // This would be used with a router to check the current route
  return false;
});

/// Provider for route protection
final familyRouteProtectionProvider = Provider<FamilyRouteProtection>((ref) {
  final state = ref.watch(familyStateProvider);
  return FamilyRouteProtection(
    hasFamily: state.currentFamily != null,
    isOwner: state.isOwner,
    isModerator: state.isModerator,
    userRole: state.userRole,
  );
});

/// Route protection class
class FamilyRouteProtection {
  final bool hasFamily;
  final bool isOwner;
  final bool isModerator;
  final FamilyRole? userRole;

  const FamilyRouteProtection({
    required this.hasFamily,
    required this.isOwner,
    required this.isModerator,
    required this.userRole,
  });

  /// Check if a route is accessible
  bool isRouteAccessible(String route) {
    if (!FamilyRoutes.isFamilyRoute(route)) return true;
    
    // Routes that don't require family selection
    if (route == FamilyRoutes.home || 
        route == FamilyRoutes.create || 
        route == FamilyRoutes.join) {
      return true;
    }
    
    // Routes that require family selection
    if (FamilyRoutes.requiresFamilySelection(route)) {
      if (!hasFamily) return false;
    }
    
    // Routes that require owner permission
    if (FamilyRoutes.requiresOwnerPermission(route)) {
      if (!isOwner) return false;
    }
    
    // Routes that require moderator permission
    if (FamilyRoutes.requiresModeratorPermission(route)) {
      if (!isOwner && !isModerator) return false;
    }
    
    return true;
  }

  /// Get the redirect route for unauthorized access
  String getRedirectRoute(String attemptedRoute) {
    if (!hasFamily && FamilyRoutes.requiresFamilySelection(attemptedRoute)) {
      return FamilyRoutes.home;
    }
    if (FamilyRoutes.requiresOwnerPermission(attemptedRoute) && !isOwner) {
      return FamilyRoutes.home;
    }
    if (FamilyRoutes.requiresModeratorPermission(attemptedRoute) && !isOwner && !isModerator) {
      return FamilyRoutes.home;
    }
    return FamilyRoutes.home;
  }

  /// Get the appropriate route for the user's current state
  String getRecommendedRoute() {
    if (!hasFamily) return FamilyRoutes.home;
    return FamilyRoutes.home;
  }
}
