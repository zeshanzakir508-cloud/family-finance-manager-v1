import '../../../repositories/transaction_repository.dart';
import '../../dto/transaction/update_transaction_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/transaction_validator.dart';

class UpdateTransactionUseCase
    implements UseCase<void, UpdateTransactionRequest> {
  final TransactionRepository _repository;
  final TransactionValidator _validator;

  const UpdateTransactionUseCase({
    required TransactionRepository repository,
    required TransactionValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateTransactionRequest params) async {
    _validator.validate(params);

    final exists = await _repository.transactionExists(
      params.transaction.id,
    );

    if (!exists) {
      throw const NotFoundException(
        'Transaction not found.',
      );
    }

    await _repository.updateTransaction(
      params.transaction,
    );
  }
}
