// lib/domain/value_objects/family_settings.dart

import 'package:equatable/equatable.dart';

/// Value object representing family settings.
class FamilySettings extends Equatable {
  /// Whether members can add comments to transactions.
  final bool allowComments;

  /// Whether income transactions are visible to all members.
  final bool showIncomeToMembers;

  /// Whether expense transactions are visible to all members.
  final bool showExpensesToMembers;

  /// Whether new member invitations require approval from an admin.
  final bool requireInvitationApproval;

  /// Whether members can create their own categories.
  final bool allowCustomCategories;

  /// Whether members can invite others to join the family.
  final bool allowMemberInvites;

  /// Whether the family budget is visible to all members.
  final bool showBudgetToMembers;

  const FamilySettings({
    this.allowComments = true,
    this.showIncomeToMembers = true,
    this.showExpensesToMembers = true,
    this.requireInvitationApproval = false,
    this.allowCustomCategories = true,
    this.allowMemberInvites = true,
    this.showBudgetToMembers = true,
  });

  /// Creates a copy of this family settings with the given fields replaced.
  FamilySettings copyWith({
    bool? allowComments,
    bool? showIncomeToMembers,
    bool? showExpensesToMembers,
    bool? requireInvitationApproval,
    bool? allowCustomCategories,
    bool? allowMemberInvites,
    bool? showBudgetToMembers,
  }) {
    return FamilySettings(
      allowComments: allowComments ?? this.allowComments,
      showIncomeToMembers: showIncomeToMembers ?? this.showIncomeToMembers,
      showExpensesToMembers: showExpensesToMembers ?? this.showExpensesToMembers,
      requireInvitationApproval:
          requireInvitationApproval ?? this.requireInvitationApproval,
      allowCustomCategories:
          allowCustomCategories ?? this.allowCustomCategories,
      allowMemberInvites: allowMemberInvites ?? this.allowMemberInvites,
      showBudgetToMembers: showBudgetToMembers ?? this.showBudgetToMembers,
    );
  }

  /// Whether members can view income.
  bool get canViewIncome => showIncomeToMembers;

  /// Whether members can view expenses.
  bool get canViewExpenses => showExpensesToMembers;

  /// Whether members can view budget.
  bool get canViewBudget => showBudgetToMembers;

  /// Whether the family allows member invites.
  bool get allowsMemberInvites => allowMemberInvites;

  @override
  List<Object?> get props => [
        allowComments,
        showIncomeToMembers,
        showExpensesToMembers,
        requireInvitationApproval,
        allowCustomCategories,
        allowMemberInvites,
        showBudgetToMembers,
      ];
}
