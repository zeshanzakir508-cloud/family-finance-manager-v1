import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/activate_subscription_request.dart';
import '../../usecases/base_usecase.dart';

class ActivateSubscriptionUseCase
    implements UseCase<void, ActivateSubscriptionRequest> {
  final SubscriptionRepository _repository;

  const ActivateSubscriptionUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(ActivateSubscriptionRequest params) async {
    await _repository.activateSubscription(
      params.userId,
    );
  }
}
