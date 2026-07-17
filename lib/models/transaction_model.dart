import 'package:json_annotation/json_annotation.dart';

import '../core/converters/date_time_converter.dart';
import '../core/converters/nullable_date_time_converter.dart';
import '../core/converters/payment_method_converter.dart';
import '../core/converters/transaction_type_converter.dart';
import '../core/enums/payment_method.dart';
import '../core/enums/transaction_type.dart';
import 'base_model.dart';

part 'transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionModel extends BaseModel {
  @override
  final String id;

  @override
  @DateTimeConverter()
  final DateTime createdAt;

  @override
  @DateTimeConverter()
  final DateTime updatedAt;

  @override
  final bool isDeleted;

  @override
  @NullableDateTimeConverter()
  final DateTime? deletedAt;

  @override
  final int version;

  /// Family ID.
  final String familyId;

  /// User who created the transaction.
  final String createdBy;

  /// Transaction type.
  @TransactionTypeConverter()
  final TransactionType type;

  /// Transaction amount.
  final double amount;

  /// Source account.
  final String accountId;

  /// Destination account (used for transfers).
  final String? transferAccountId;

  /// Category ID.
  final String categoryId;

  /// Payment method.
  @PaymentMethodConverter()
  final PaymentMethod paymentMethod;

  /// Actual transaction date.
  @DateTimeConverter()
  final DateTime transactionDate;

  /// Person for whom the expense was made.
  final String? spentForUserId;

  /// Optional title.
  final String? title;

  /// Optional notes.
  final String? notes;

  /// Receipt / invoice attachments.
  final List<String> attachmentUrls;

  const TransactionModel({
    required this.id,
    @DateTimeConverter()
    required this.createdAt,
    @DateTimeConverter()
    required this.updatedAt,
    this.isDeleted = false,
    @NullableDateTimeConverter()
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    required this.createdBy,
    required this.type,
    required this.amount,
    required this.accountId,
    this.transferAccountId,
    required this.categoryId,
    this.paymentMethod = PaymentMethod.other,
    @DateTimeConverter()
    required this.transactionDate,
    this.spentForUserId,
    this.title,
    this.notes,
    this.attachmentUrls = const [],
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? createdBy,
    TransactionType? type,
    double? amount,
    String? accountId,
    String? transferAccountId,
    String? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? transactionDate,
    String? spentForUserId,
    String? title,
    String? notes,
    List<String>? attachmentUrls,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      createdBy: createdBy ?? this.createdBy,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      transferAccountId:
          transferAccountId ?? this.transferAccountId,
      categoryId: categoryId ?? this.categoryId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionDate:
          transactionDate ?? this.transactionDate,
      spentForUserId:
          spentForUserId ?? this.spentForUserId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      attachmentUrls:
          attachmentUrls ?? this.attachmentUrls,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, type: $type, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
