import '../../../domain/dto/transaction/create_transaction_request.dart';
import '../../../domain/usecases/base_usecase.dart';
import '../../../repositories/transaction_repository.dart';
import '../../validators/transaction_validator.dart';

/// Creates a new transaction.
///
/// Flow:
/// Request
///   ↓
/// Validate
///   ↓
/// Repository
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
    // Validate input.
    _validator.validate(params);

    // Persist transaction.
    await _repository.createTransaction(params.transaction);
  }
}
