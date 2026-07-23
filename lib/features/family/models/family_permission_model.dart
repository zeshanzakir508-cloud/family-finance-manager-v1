import 'package:flutter/foundation.dart';
import '../enums/permission_type.dart';

/// Model representing permissions for a family member
class FamilyPermissionModel {
  /// Unique identifier
  final String id;
  
  /// Family ID
  final String familyId;
  
  /// Member ID
  final String memberId;
  
  /// List of granted permissions
  final List<PermissionType> permissions;
  
  /// Timestamp when permissions were granted
  final DateTime grantedAt;
  
  /// ID of the member who granted these permissions
  final String grantedBy;
  
  /// Any additional metadata
  final Map<String, dynamic>? metadata;

  /// Constructor
  const FamilyPermissionModel({
    required this.id,
    required this.familyId,
    required this.memberId,
    required this.permissions,
    required this.grantedAt,
    required this.grantedBy,
    this.metadata,
  });

  /// Create from JSON
  factory FamilyPermissionModel.fromJson(Map<String, dynamic> json) {
    final permissionStrings = List<String>.from(json['permissions'] ?? []);
    final permissions = permissionStrings
        .map((p) => PermissionTypeExtension.fromString(p))
        .toList();

    return FamilyPermissionModel(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      memberId: json['memberId'] as String,
      permissions: permissions,
      grantedAt: DateTime.parse(json['grantedAt'] as String),
      grantedBy: json['grantedBy'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'familyId': familyId,
      'memberId': memberId,
      'permissions': permissions.map((p) => p.name).toList(),
      'grantedAt': grantedAt.toIso8601String(),
      'grantedBy': grantedBy,
      'metadata': metadata,
    };
  }

  /// Check if a specific permission is granted
  bool hasPermission(PermissionType permission) {
    return permissions.contains(permission);
  }

  /// Check if any of the provided permissions are granted
  bool hasAnyPermission(List<PermissionType> checkPermissions) {
    return checkPermissions.any((p) => permissions.contains(p));
  }

  /// Check if all of the provided permissions are granted
  bool hasAllPermissions(List<PermissionType> checkPermissions) {
    return checkPermissions.every((p) => permissions.contains(p));
  }

  /// Get the permission count
  int get count => permissions.length;

  /// Get permissions by category
  Map<String, List<PermissionType>> getPermissionsByCategory() {
    final categorized = <String, List<PermissionType>>{};
    for (final permission in permissions) {
      final category = permission.category;
      categorized.putIfAbsent(category, () => []);
      categorized[category]!.add(permission);
    }
    return categorized;
  }

  /// Create a copy with updated fields
  FamilyPermissionModel copyWith({
    String? id,
    String? familyId,
    String? memberId,
    List<PermissionType>? permissions,
    DateTime? grantedAt,
    String? grantedBy,
    Map<String, dynamic>? metadata,
  }) {
    return FamilyPermissionModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
      permissions: permissions ?? this.permissions,
      grantedAt: grantedAt ?? this.grantedAt,
      grantedBy: grantedBy ?? this.grantedBy,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Add a permission
  FamilyPermissionModel addPermission(PermissionType permission) {
    if (permissions.contains(permission)) return this;
    return copyWith(
      permissions: [...permissions, permission],
    );
  }

  /// Remove a permission
  FamilyPermissionModel removePermission(PermissionType permission) {
    if (!permissions.contains(permission)) return this;
    return copyWith(
      permissions: permissions.where((p) => p != permission).toList(),
    );
  }

  /// Toggle a permission
  FamilyPermissionModel togglePermission(PermissionType permission) {
    if (permissions.contains(permission)) {
      return removePermission(permission);
    } else {
      return addPermission(permission);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyPermissionModel &&
        other.id == id &&
        other.familyId == familyId &&
        other.memberId == memberId &&
        listEquals(other.permissions, permissions) &&
        other.grantedAt == grantedAt &&
        other.grantedBy == grantedBy &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyId,
      memberId,
      Object.hashAll(permissions),
      grantedAt,
      grantedBy,
      metadata,
    );
  }

  @override
  String toString() {
    return 'FamilyPermissionModel(memberId: $memberId, permissions: ${permissions.length})';
  }
}
