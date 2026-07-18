import '../../../repositories/transaction_repository.dart';
import '../../dto/transaction/create_transaction_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/transaction_validator.dart';

class CreateTransactionUseCase
    implements UseCase<void, CreateTransactionRequest> {
  final TransactionRepository _repository;
  final TransactionValidator _validator;

  const CreateTransactionUseCase({
    required TransactionRepository repository,
    required TransactionValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateTransactionRequest params) async {
    _validator.validate(params);

    await _repository.createTransaction(params.transaction);
  }
}
