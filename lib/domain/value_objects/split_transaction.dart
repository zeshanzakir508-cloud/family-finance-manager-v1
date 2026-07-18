// lib/domain/value_objects/split_transaction.dart

import 'package:equatable/equatable.dart';

/// Value object representing a split transaction.
///
/// A split transaction is a portion of a larger transaction that
/// is allocated to a specific category.
class SplitTransaction extends Equatable {
  /// The category ID for this split.
  final String categoryId;

  /// The amount allocated to this split.
  final double amount;

  /// Optional description for this split.
  final String? description;

  const SplitTransaction({
    required this.categoryId,
    required this.amount,
    this.description,
  })  : assert(categoryId.isNotEmpty, 'Category ID cannot be empty'),
        assert(amount > 0, 'Split amount must be greater than zero');

  /// Creates a copy of this split transaction with the given fields replaced.
  SplitTransaction copyWith({
    String? categoryId,
    double? amount,
    String? description,
  }) {
    return SplitTransaction(
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        amount,
        description,
      ];
}
