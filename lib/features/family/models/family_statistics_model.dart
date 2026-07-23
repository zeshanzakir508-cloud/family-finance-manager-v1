import 'package:flutter/foundation.dart';

/// Model representing family statistics
class FamilyStatisticsModel {
  /// Family ID
  final String familyId;
  
  /// Total number of members
  final int totalMembers;
  
  /// Number of active members
  final int activeMembers;
  
  /// Number of pending members
  final int pendingMembers;
  
  /// Number of suspended members
  final int suspendedMembers;
  
  /// Total number of accounts
  final int totalAccounts;
  
  /// Total number of categories
  final int totalCategories;
  
  /// Total number of transactions
  final int totalTransactions;
  
  /// Total transaction amount
  final double totalAmount;
  
  /// Average transaction amount
  final double averageAmount;
  
  /// Total income
  final double totalIncome;
  
  /// Total expenses
  final double totalExpenses;
  
  /// Current balance
  final double balance;
  
  /// Family activity count in the last 30 days
  final int activityCount30Days;
  
  /// Number of invitations pending
  final int pendingInvites;
  
  /// Timestamp when the statistics were updated
  final DateTime updatedAt;

  /// Constructor
  const FamilyStatisticsModel({
    required this.familyId,
    this.totalMembers = 0,
    this.activeMembers = 0,
    this.pendingMembers = 0,
    this.suspendedMembers = 0,
    this.totalAccounts = 0,
    this.totalCategories = 0,
    this.totalTransactions = 0,
    this.totalAmount = 0,
    this.averageAmount = 0,
    this.totalIncome = 0,
    this.totalExpenses = 0,
    this.balance = 0,
    this.activityCount30Days = 0,
    this.pendingInvites = 0,
    required this.updatedAt,
  });

  /// Create from JSON
  factory FamilyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FamilyStatisticsModel(
      familyId: json['familyId'] as String,
      totalMembers: json['totalMembers'] as int? ?? 0,
      activeMembers: json['activeMembers'] as int? ?? 0,
      pendingMembers: json['pendingMembers'] as int? ?? 0,
      suspendedMembers: json['suspendedMembers'] as int? ?? 0,
      totalAccounts: json['totalAccounts'] as int? ?? 0,
      totalCategories: json['totalCategories'] as int? ?? 0,
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      averageAmount: (json['averageAmount'] as num?)?.toDouble() ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      activityCount30Days: json['activityCount30Days'] as int? ?? 0,
      pendingInvites: json['pendingInvites'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'familyId': familyId,
      'totalMembers': totalMembers,
      'activeMembers': activeMembers,
      'pendingMembers': pendingMembers,
      'suspendedMembers': suspendedMembers,
      'totalAccounts': totalAccounts,
      'totalCategories': totalCategories,
      'totalTransactions': totalTransactions,
      'totalAmount': totalAmount,
      'averageAmount': averageAmount,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'balance': balance,
      'activityCount30Days': activityCount30Days,
      'pendingInvites': pendingInvites,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get the number of inactive members
  int get inactiveMembers {
    return totalMembers - activeMembers;
  }

  /// Get the percentage of active members
  double get activeMembersPercentage {
    if (totalMembers == 0) return 0;
    return activeMembers / totalMembers;
  }

  /// Get the net income/expense
  double get netIncome {
    return totalIncome - totalExpenses;
  }

  /// Check if the family has a positive balance
  bool get hasPositiveBalance {
    return balance > 0;
  }

  /// Check if the family has a negative balance
  bool get hasNegativeBalance {
    return balance < 0;
  }

  /// Check if the family is active (has members)
  bool get hasActiveMembers {
    return activeMembers > 0;
  }

  /// Check if the family has any activity
  bool get hasActivity {
    return totalTransactions > 0 || activityCount30Days > 0;
  }

  /// Get the member distribution as a map
  Map<String, int> get memberDistribution {
    return {
      'Active': activeMembers,
      'Pending': pendingMembers,
      'Suspended': suspendedMembers,
      'Inactive': inactiveMembers,
    };
  }

  /// Create a copy with updated fields
  FamilyStatisticsModel copyWith({
    String? familyId,
    int? totalMembers,
    int? activeMembers,
    int? pendingMembers,
    int? suspendedMembers,
    int? totalAccounts,
    int? totalCategories,
    int? totalTransactions,
    double? totalAmount,
    double? averageAmount,
    double? totalIncome,
    double? totalExpenses,
    double? balance,
    int? activityCount30Days,
    int? pendingInvites,
    DateTime? updatedAt,
  }) {
    return FamilyStatisticsModel(
      familyId: familyId ?? this.familyId,
      totalMembers: totalMembers ?? this.totalMembers,
      activeMembers: activeMembers ?? this.activeMembers,
      pendingMembers: pendingMembers ?? this.pendingMembers,
      suspendedMembers: suspendedMembers ?? this.suspendedMembers,
      totalAccounts: totalAccounts ?? this.totalAccounts,
      totalCategories: totalCategories ?? this.totalCategories,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalAmount: totalAmount ?? this.totalAmount,
      averageAmount: averageAmount ?? this.averageAmount,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      balance: balance ?? this.balance,
      activityCount30Days: activityCount30Days ?? this.activityCount30Days,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyStatisticsModel &&
        other.familyId == familyId &&
        other.totalMembers == totalMembers &&
        other.activeMembers == activeMembers &&
        other.pendingMembers == pendingMembers &&
        other.suspendedMembers == suspendedMembers &&
        other.totalAccounts == totalAccounts &&
        other.totalCategories == totalCategories &&
        other.totalTransactions == totalTransactions &&
        other.totalAmount == totalAmount &&
        other.averageAmount == averageAmount &&
        other.totalIncome == totalIncome &&
        other.totalExpenses == totalExpenses &&
        other.balance == balance &&
        other.activityCount30Days == activityCount30Days &&
        other.pendingInvites == pendingInvites &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      familyId,
      totalMembers,
      activeMembers,
      pendingMembers,
      suspendedMembers,
      totalAccounts,
      totalCategories,
      totalTransactions,
      totalAmount,
      averageAmount,
      totalIncome,
      totalExpenses,
      balance,
      activityCount30Days,
      pendingInvites,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'FamilyStatisticsModel(familyId: $familyId, totalMembers: $totalMembers, balance: $balance)';
  }
}
