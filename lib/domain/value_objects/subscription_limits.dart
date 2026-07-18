// lib/domain/value_objects/subscription_limits.dart

import 'package:equatable/equatable.dart';

/// Value object representing subscription limits.
///
/// null values represent unlimited limits.
class SubscriptionLimits extends Equatable {
  /// Maximum number of users allowed. null = unlimited.
  final int? maxUsers;

  /// Maximum number of accounts allowed. null = unlimited.
  final int? maxAccounts;

  /// Maximum number of categories allowed. null = unlimited.
  final int? maxCategories;

  /// Maximum number of transactions allowed. null = unlimited.
  final int? maxTransactions;

  const SubscriptionLimits({
    this.maxUsers = 1,
    this.maxAccounts = 5,
    this.maxCategories = 20,
    this.maxTransactions = 1000,
  })  : assert(maxUsers == null || maxUsers > 0, 'Max users must be greater than 0'),
        assert(maxAccounts == null || maxAccounts > 0, 'Max accounts must be greater than 0'),
        assert(maxCategories == null || maxCategories > 0, 'Max categories must be greater than 0'),
        assert(maxTransactions == null || maxTransactions > 0, 'Max transactions must be greater than 0');

  /// Creates a copy of these subscription limits with the given fields replaced.
  SubscriptionLimits copyWith({
    int? maxUsers,
    int? maxAccounts,
    int? maxCategories,
    int? maxTransactions,
  }) {
    return SubscriptionLimits(
      maxUsers: maxUsers ?? this.maxUsers,
      maxAccounts: maxAccounts ?? this.maxAccounts,
      maxCategories: maxCategories ?? this.maxCategories,
      maxTransactions: maxTransactions ?? this.maxTransactions,
    );
  }

  /// Returns whether all limits are unlimited.
  bool get isUnlimited =>
      maxUsers == null &&
      maxAccounts == null &&
      maxCategories == null &&
      maxTransactions == null;

  /// Returns whether the plan has any limits set.
  bool get hasLimits => !isUnlimited;

  @override
  List<Object?> get props => [
        maxUsers,
        maxAccounts,
        maxCategories,
        maxTransactions,
      ];
}
