import '../../../models/transaction_model.dart';

/// Request object for creating a transaction.
///
/// Keeping parameters inside one immutable object makes use cases
/// easier to maintain and extend over time.
class CreateTransactionRequest {
  final TransactionModel transaction;

  const CreateTransactionRequest({
    required this.transaction,
  });
}
