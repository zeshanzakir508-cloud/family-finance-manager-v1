import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/extend_subscription_request.dart';
import '../../usecases/base_usecase.dart';

class ExtendSubscriptionUseCase
    implements UseCase<void, ExtendSubscriptionRequest> {
  final SubscriptionRepository _repository;

  const ExtendSubscriptionUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(ExtendSubscriptionRequest params) async {
    await _repository.extendSubscription(
      userId: params.userId,
      expiryDate: params.expiryDate,
    );
  }
}
