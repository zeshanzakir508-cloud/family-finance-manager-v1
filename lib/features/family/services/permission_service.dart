import '../enums/family_role.dart';
import '../enums/permission_type.dart';

/// Interface for permission service operations
abstract class PermissionService {
  /// Get all permissions for a member
  Future<List<PermissionType>> getMemberPermissions(String familyId, String memberId);

  /// Check if a member has a specific permission
  Future<bool> hasPermission(String familyId, String memberId, PermissionType permission);

  /// Check if a member has any of the given permissions
  Future<bool> hasAnyPermission(String familyId, String memberId, List<PermissionType> permissions);

  /// Check if a member has all of the given permissions
  Future<bool> hasAllPermissions(String familyId, String memberId, List<PermissionType> permissions);

  /// Grant a permission to a member
  Future<void> grantPermission(String familyId, String memberId, PermissionType permission);

  /// Revoke a permission from a member
  Future<void> revokePermission(String familyId, String memberId, PermissionType permission);

  /// Toggle a permission for a member
  Future<bool> togglePermission(String familyId, String memberId, PermissionType permission);

  /// Get permissions by role
  List<PermissionType> getPermissionsForRole(FamilyRole role);

  /// Check if a role has a specific permission
  bool roleHasPermission(FamilyRole role, PermissionType permission);

  /// Get all available permissions
  List<PermissionType> getAllPermissions();

  /// Get permissions by category
  List<PermissionType> getPermissionsByCategory(String category);

  /// Get all permission categories
  List<String> getPermissionCategories();

  /// Get default permissions for a role
  List<PermissionType> getDefaultPermissionsForRole(FamilyRole role);

  /// Check if a permission is valid
  bool isValidPermission(PermissionType permission);

  /// Compare two permission sets
  bool permissionSetsEqual(List<PermissionType> a, List<PermissionType> b);

  /// Get permission differences between two sets
  Map<String, List<PermissionType>> getPermissionDifferences(
    List<PermissionType> oldPermissions,
    List<PermissionType> newPermissions,
  );

  /// Merge permission sets
  List<PermissionType> mergePermissions(List<PermissionType> a, List<PermissionType> b);

  /// Remove duplicates from a permission set
  List<PermissionType> deduplicatePermissions(List<PermissionType> permissions);

  /// Sort permissions alphabetically
  List<PermissionType> sortPermissions(List<PermissionType> permissions);

  /// Group permissions by category
  Map<String, List<PermissionType>> groupPermissionsByCategory(List<PermissionType> permissions);

  /// Check if a permission set is a subset of another
  bool isSubsetOf(List<PermissionType> subset, List<PermissionType> superset);

  /// Check if a permission set is a superset of another
  bool isSupersetOf(List<PermissionType> superset, List<PermissionType> subset);

  /// Get permission count by category
  Map<String, int> getPermissionCountByCategory(List<PermissionType> permissions);

  /// Get permission summary
  Map<String, dynamic> getPermissionSummary(List<PermissionType> permissions);

  /// Convert permission to string
  String permissionToString(PermissionType permission);

  /// Convert string to permission
  PermissionType stringToPermission(String value);

  /// Convert permissions to strings
  List<String> permissionsToStrings(List<PermissionType> permissions);

  /// Convert strings to permissions
  List<PermissionType> stringsToPermissions(List<String> values);
}
