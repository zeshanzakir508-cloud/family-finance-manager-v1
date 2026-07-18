import '../../../repositories/transaction_repository.dart';
import '../../dto/transaction/restore_transaction_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class RestoreTransactionUseCase
    implements UseCase<void, RestoreTransactionRequest> {
  final TransactionRepository _repository;

  const RestoreTransactionUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RestoreTransactionRequest params,
  ) async {
    final exists = await _repository.transactionExists(
      params.transactionId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Transaction not found.',
      );
    }

    await _repository.restoreTransaction(
      params.transactionId,
    );
  }
}
