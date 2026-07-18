// lib/domain/entities/family_member.dart

import 'package:equatable/equatable.dart';

import '../enums/family_role.dart';
import '../value_objects/member_permissions.dart';

/// Family member entity representing a user's membership in a family.
///
/// This entity tracks the relationship between a user and a family,
/// including their role, permissions, and join date.
class FamilyMember extends Equatable {
  /// Unique identifier for the family member record.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the family this member belongs to.
  final String familyId;

  /// ID of the user who is a member of the family.
  final String userId;

  /// Email of the member (denormalized for quick access).
  final String email;

  /// Display name of the member (denormalized for quick access).
  final String displayName;

  /// URL to the member's profile photo (denormalized).
  final String? photoUrl;

  /// Role of the member in the family.
  final FamilyRole role;

  /// Permissions for fine-grained access control.
  final MemberPermissions permissions;

  /// Date when the member joined the family.
  final DateTime joinedAt;

  /// ID of the user who invited this member (if any).
  final String? invitedBy;

  /// Whether the member is active in the family.
  final bool isActive;

  const FamilyMember({
    this.id,
    required this.familyId,
    required this.userId,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = FamilyRole.member,
    this.permissions = const MemberPermissions(),
    required this.joinedAt,
    this.invitedBy,
    this.isActive = true,
  });

  /// Creates a copy of this family member with the given fields replaced.
  FamilyMember copyWith({
    String? id,
    String? familyId,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    FamilyRole? role,
    MemberPermissions? permissions,
    DateTime? joinedAt,
    String? invitedBy,
    bool? isActive,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      joinedAt: joinedAt ?? this.joinedAt,
      invitedBy: invitedBy ?? this.invitedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Returns whether the member is an admin.
  bool get isAdmin => role == FamilyRole.admin;

  /// Returns whether the member is the owner.
  bool get isOwner => role == FamilyRole.owner;

  /// Returns whether the member can manage other members.
  bool get canManageMembers =>
      isOwner || isAdmin || permissions.manageMembers;

  /// Returns whether the member can manage family settings.
  bool get canManageSettings =>
      isOwner || isAdmin || permissions.manageSettings;

  /// Returns whether the member can view family finances.
  bool get canViewFinances =>
      isOwner || isAdmin || permissions.viewFinances;

  /// Returns whether the member can edit transactions.
  bool get canEditTransactions =>
      isOwner || isAdmin || permissions.editTransactions;

  /// Returns whether the member can delete transactions.
  bool get canDeleteTransactions =>
      isOwner || isAdmin || permissions.deleteTransactions;

  /// Returns whether the member can manage categories.
  bool get canManageCategories =>
      isOwner || isAdmin || permissions.manageCategories;

  @override
  List<Object?> get props => [
        id,
        familyId,
        userId,
        email,
        displayName,
        photoUrl,
        role,
        permissions,
        joinedAt,
        invitedBy,
        isActive,
      ];
}
