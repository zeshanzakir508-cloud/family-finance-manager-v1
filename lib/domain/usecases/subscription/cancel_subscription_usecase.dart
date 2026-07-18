import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/cancel_subscription_request.dart';
import '../../usecases/base_usecase.dart';

class CancelSubscriptionUseCase
    implements UseCase<void, CancelSubscriptionRequest> {
  final SubscriptionRepository _repository;

  const CancelSubscriptionUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(CancelSubscriptionRequest params) async {
    await _repository.cancelSubscription(
      params.userId,
    );
  }
}
