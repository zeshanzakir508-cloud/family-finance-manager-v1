import 'package:flutter/foundation.dart';

/// Model representing a financial account
class AccountModel {
  /// Unique identifier
  final String id;
  
  /// Account name
  final String name;
  
  /// Account description (optional)
  final String? description;
  
  /// Opening balance
  final double openingBalance;
  
  /// Current balance (calculated from transactions)
  final double currentBalance;
  
  /// Icon for the account
  final String icon;
  
  /// Color for the account
  final String color;
  
  /// Whether the account is archived
  final bool isArchived;
  
  /// Family ID if account belongs to a family
  final String? familyId;
  
  /// User ID who owns the account
  final String userId;
  
  /// Timestamp when account was created
  final DateTime createdAt;
  
  /// Timestamp when account was last updated
  final DateTime updatedAt;
  
  /// Timestamp when account was last used
  final DateTime? lastUsedAt;

  /// Constructor
  const AccountModel({
    required this.id,
    required this.name,
    this.description,
    required this.openingBalance,
    this.currentBalance = 0.0,
    this.icon = 'wallet',
    this.color = '#4ECDC4',
    this.isArchived = false,
    this.familyId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.lastUsedAt,
  });

  /// Create from JSON
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      openingBalance: (json['openingBalance'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] as String? ?? 'wallet',
      color: json['color'] as String? ?? '#4ECDC4',
      isArchived: json['isArchived'] as bool? ?? false,
      familyId: json['familyId'] as String?,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'icon': icon,
      'color': color,
      'isArchived': isArchived,
      'familyId': familyId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  AccountModel copyWith({
    String? id,
    String? name,
    String? description,
    double? openingBalance,
    double? currentBalance,
    String? icon,
    String? color,
    bool? isArchived,
    String? familyId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUsedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isArchived: isArchived ?? this.isArchived,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Check if account has a balance (non-zero)
  bool get hasBalance => currentBalance != 0;

  /// Check if account has a positive balance
  bool get hasPositiveBalance => currentBalance > 0;

  /// Check if account has a negative balance
  bool get hasNegativeBalance => currentBalance < 0;

  /// Check if account is active (not archived)
  bool get isActive => !isArchived;

  /// Check if account belongs to a family
  bool get isFamilyAccount => familyId != null;

  /// Check if account belongs to a user
  bool get isPersonalAccount => familyId == null;

  /// Get the balance as a formatted string
  String get formattedBalance => '\$${currentBalance.toStringAsFixed(2)}';

  /// Get the opening balance as a formatted string
  String get formattedOpeningBalance => '\$${openingBalance.toStringAsFixed(2)}';

  /// Get the account icon emoji
  String get iconEmoji {
    const iconMap = {
      'wallet': '💰',
      'bank': '🏦',
      'cash': '💵',
      'credit_card': '💳',
      'savings': '🏺',
      'investment': '📈',
      'piggy_bank': '🐷',
      'money_bag': '💰',
    };
    return iconMap[icon] ?? '💰';
  }

  /// Get the account color as Color
  int get colorValue {
    try {
      return int.parse('FF${color.replaceFirst('#', '')}', radix: 16);
    } catch (e) {
      return 0xFF4ECDC4;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.openingBalance == openingBalance &&
        other.currentBalance == currentBalance &&
        other.icon == icon &&
        other.color == color &&
        other.isArchived == isArchived &&
        other.familyId == familyId &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.lastUsedAt == lastUsedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      openingBalance,
      currentBalance,
      icon,
      color,
      isArchived,
      familyId,
      userId,
      createdAt,
      updatedAt,
      lastUsedAt,
    );
  }

  @override
  String toString() {
    return 'AccountModel(id: $id, name: $name, balance: $currentBalance, isArchived: $isArchived)';
  }
}
