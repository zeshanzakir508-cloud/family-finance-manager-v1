import '../../../repositories/account_repository.dart';
import '../../dto/account/create_account_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/account_validator.dart';

class CreateAccountUseCase
    implements UseCase<void, CreateAccountRequest> {
  final AccountRepository _repository;
  final AccountValidator _validator;

  const CreateAccountUseCase({
    required AccountRepository repository,
    required AccountValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateAccountRequest params) async {
    _validator.validate(params);

    await _repository.createAccount(params.account);
  }
}
