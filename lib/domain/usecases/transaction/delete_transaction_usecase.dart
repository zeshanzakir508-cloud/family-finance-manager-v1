import '../../../repositories/transaction_repository.dart';
import '../../dto/transaction/delete_transaction_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class DeleteTransactionUseCase
    implements UseCase<void, DeleteTransactionRequest> {
  final TransactionRepository _repository;

  const DeleteTransactionUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteTransactionRequest params) async {
    final exists = await _repository.transactionExists(
      params.transactionId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Transaction not found.',
      );
    }

    await _repository.deleteTransaction(
      params.transactionId,
    );
  }
}
