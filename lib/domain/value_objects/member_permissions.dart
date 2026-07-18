// lib/domain/value_objects/member_permissions.dart

import 'package:equatable/equatable.dart';

/// Value object representing family member permissions.
///
/// These permissions define what actions a member can perform within a family.
/// They work in conjunction with the member's role (owner/admin/member/guest).
class MemberPermissions extends Equatable {
  /// Whether the member can manage other members (add/remove).
  final bool manageMembers;

  /// Whether the member can manage family settings.
  final bool manageSettings;

  /// Whether the member can view family financial data.
  final bool viewFinances;

  /// Whether the member can edit transactions.
  final bool editTransactions;

  /// Whether the member can delete transactions.
  final bool deleteTransactions;

  /// Whether the member can manage categories.
  final bool manageCategories;

  /// Whether the member can invite new members.
  final bool inviteMembers;

  /// Whether the member can export family data.
  final bool exportData;

  const MemberPermissions({
    this.manageMembers = false,
    this.manageSettings = false,
    this.viewFinances = false,
    this.editTransactions = false,
    this.deleteTransactions = false,
    this.manageCategories = false,
    this.inviteMembers = false,
    this.exportData = false,
  });

  /// Creates a copy of this member permissions with the given fields replaced.
  MemberPermissions copyWith({
    bool? manageMembers,
    bool? manageSettings,
    bool? viewFinances,
    bool? editTransactions,
    bool? deleteTransactions,
    bool? manageCategories,
    bool? inviteMembers,
    bool? exportData,
  }) {
    return MemberPermissions(
      manageMembers: manageMembers ?? this.manageMembers,
      manageSettings: manageSettings ?? this.manageSettings,
      viewFinances: viewFinances ?? this.viewFinances,
      editTransactions: editTransactions ?? this.editTransactions,
      deleteTransactions: deleteTransactions ?? this.deleteTransactions,
      manageCategories: manageCategories ?? this.manageCategories,
      inviteMembers: inviteMembers ?? this.inviteMembers,
      exportData: exportData ?? this.exportData,
    );
  }

  /// Returns true if the member has all permissions (full access).
  bool get hasFullAccess => manageMembers &&
      manageSettings &&
      viewFinances &&
      editTransactions &&
      deleteTransactions &&
      manageCategories &&
      inviteMembers &&
      exportData;

  /// Returns true if the member has no permissions.
  bool get hasNoPermissions => !manageMembers &&
      !manageSettings &&
      !viewFinances &&
      !editTransactions &&
      !deleteTransactions &&
      !manageCategories &&
      !inviteMembers &&
      !exportData;

  /// Returns true if the member can manage members.
  bool get canManageMembers => manageMembers;

  /// Returns true if the member can manage settings.
  bool get canManageSettings => manageSettings;

  /// Returns true if the member can view finances.
  bool get canViewFinances => viewFinances;

  /// Returns true if the member can edit transactions.
  bool get canEditTransactions => editTransactions;

  /// Returns true if the member can delete transactions.
  bool get canDeleteTransactions => deleteTransactions;

  /// Returns true if the member can manage categories.
  bool get canManageCategories => manageCategories;

  /// Returns true if the member can invite members.
  bool get canInviteMembers => inviteMembers;

  /// Returns true if the member can export data.
  bool get canExportData => exportData;

  @override
  List<Object?> get props => [
        manageMembers,
        manageSettings,
        viewFinances,
        editTransactions,
        deleteTransactions,
        manageCategories,
        inviteMembers,
        exportData,
      ];
}
