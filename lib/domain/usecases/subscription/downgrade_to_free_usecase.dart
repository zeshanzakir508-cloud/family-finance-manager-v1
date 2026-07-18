import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/downgrade_to_free_request.dart';
import '../../usecases/base_usecase.dart';

class DowngradeToFreeUseCase
    implements UseCase<void, DowngradeToFreeRequest> {
  final SubscriptionRepository _repository;

  const DowngradeToFreeUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DowngradeToFreeRequest params) async {
    await _repository.downgradeToFree(
      params.userId,
    );
  }
}
