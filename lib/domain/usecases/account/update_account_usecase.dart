import '../../../repositories/account_repository.dart';
import '../../dto/account/update_account_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/account_validator.dart';

class UpdateAccountUseCase
    implements UseCase<void, UpdateAccountRequest> {
  final AccountRepository _repository;
  final AccountValidator _validator;

  const UpdateAccountUseCase({
    required AccountRepository repository,
    required AccountValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateAccountRequest params) async {
    _validator.validate(params);

    final exists = await _repository.accountExists(
      params.account.id,
    );

    if (!exists) {
      throw const NotFoundException('Account not found.');
    }

    await _repository.updateAccount(params.account);
  }
}
