import '../../../models/transaction_model.dart';

class UpdateTransactionRequest {
  final TransactionModel transaction;

  const UpdateTransactionRequest({
    required this.transaction,
  });
}
