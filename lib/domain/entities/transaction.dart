// lib/domain/entities/transaction.dart

import 'package:equatable/equatable.dart';

import '../enums/transaction_type.dart';
import '../enums/recurring_type.dart';
import 'split_transaction.dart';

/// Transaction entity representing a financial transaction.
///
/// This is a domain entity that contains only business-relevant fields.
/// Persistence-managed fields like [id], [createdAt], and [updatedAt]
/// are handled by the data layer.
class Transaction extends Equatable {
  /// Unique identifier for the transaction.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the user who owns the transaction.
  final String userId;

  /// ID of the account this transaction belongs to.
  final String accountId;

  /// ID of the category this transaction belongs to.
  final String categoryId;

  /// Amount of the transaction (positive number).
  final double amount;

  /// Description of the transaction.
  final String description;

  /// Type of transaction (income or expense).
  final TransactionType type;

  /// Date of the transaction.
  final DateTime date;

  /// Whether this transaction is recurring.
  final bool isRecurring;

  /// Type of recurrence (daily, weekly, monthly, yearly).
  final RecurringType? recurringType;

  /// Interval for recurring transactions (e.g., every 2 weeks).
  final int? recurringInterval;

  /// ID of the parent transaction if this is a split transaction.
  final String? parentTransactionId;

  /// ID of the family this transaction belongs to (if any).
  final String? familyId;

  /// Whether this transaction is split into multiple categories.
  final bool isSplit;

  /// List of split transactions (if isSplit is true).
  final List<SplitTransaction>? splitTransactions;

  /// List of attachment URLs or file paths.
  final List<String>? attachments;

  /// List of tags for categorization.
  final List<String>? tags;

  /// Additional notes for the transaction.
  final String? notes;

  /// Location of the transaction.
  final String? location;

  const Transaction({
    this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.type,
    required this.date,
    this.isRecurring = false,
    this.recurringType,
    this.recurringInterval,
    this.parentTransactionId,
    this.familyId,
    this.isSplit = false,
    this.splitTransactions,
    this.attachments,
    this.tags,
    this.notes,
    this.location,
  });

  /// Creates a copy of this transaction with the given fields replaced.
  Transaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? categoryId,
    double? amount,
    String? description,
    TransactionType? type,
    DateTime? date,
    bool? isRecurring,
    RecurringType? recurringType,
    int? recurringInterval,
    String? parentTransactionId,
    String? familyId,
    bool? isSplit,
    List<SplitTransaction>? splitTransactions,
    List<String>? attachments,
    List<String>? tags,
    String? notes,
    String? location,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      recurringInterval: recurringInterval ?? this.recurringInterval,
      parentTransactionId: parentTransactionId ?? this.parentTransactionId,
      familyId: familyId ?? this.familyId,
      isSplit: isSplit ?? this.isSplit,
      splitTransactions: splitTransactions ?? this.splitTransactions,
      attachments: attachments ?? this.attachments,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        accountId,
        categoryId,
        amount,
        description,
        type,
        date,
        isRecurring,
        recurringType,
        recurringInterval,
        parentTransactionId,
        familyId,
        isSplit,
        splitTransactions,
        attachments,
        tags,
        notes,
        location,
      ];
}
