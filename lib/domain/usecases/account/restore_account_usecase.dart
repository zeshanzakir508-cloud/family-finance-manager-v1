import '../../../repositories/account_repository.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class RestoreAccountUseCase
    implements UseCase<void, String> {
  final AccountRepository _repository;

  const RestoreAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(String accountId) async {
    final exists = await _repository.accountExists(accountId);

    if (!exists) {
      throw const NotFoundException('Account not found.');
    }

    await _repository.restoreAccount(accountId);
  }
}
