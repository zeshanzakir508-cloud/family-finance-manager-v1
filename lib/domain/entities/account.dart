// lib/domain/entities/account.dart

import 'package:equatable/equatable.dart';

/// Account entity representing a financial account.
///
/// This is a domain entity with optional fields for persistence concerns.
/// The [id], [createdAt], and [updatedAt] fields are nullable to indicate
/// they are set by the persistence layer, not by the domain layer.
class Account extends Equatable {
  /// Unique identifier for the account.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the user who owns the account.
  final String userId;

  /// Name of the account.
  final String name;

  /// Type of account (bank, cash, credit_card, etc.).
  final String type;

  /// Current balance of the account.
  final double balance;

  /// Currency code (ISO 4217) for the account.
  final String currency;

  /// Whether this is the user's default account.
  final bool isDefault;

  /// Whether the account is active.
  final bool isActive;

  /// Icon name or emoji for the account.
  final String? icon;

  /// Color hex code for the account.
  final String? color;

  /// Optional description of the account.
  final String? description;

  /// ID of the family this account belongs to (if any).
  final String? familyId;

  /// Creation timestamp. Set by the persistence layer.
  final DateTime? createdAt;

  /// Last update timestamp. Set by the persistence layer.
  final DateTime? updatedAt;

  const Account({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.balance = 0.0,
    this.currency = 'USD',
    this.isDefault = false,
    this.isActive = true,
    this.icon,
    this.color,
    this.description,
    this.familyId,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy of this account with the given fields replaced.
  Account copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    double? balance,
    String? currency,
    bool? isDefault,
    bool? isActive,
    String? icon,
    String? color,
    String? description,
    String? familyId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      familyId: familyId ?? this.familyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        balance,
        currency,
        isDefault,
        isActive,
        icon,
        color,
        description,
        familyId,
        createdAt,
        updatedAt,
      ];
}
