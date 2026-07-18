import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/validate_subscription_request.dart';
import '../../usecases/base_usecase.dart';

class ValidateSubscriptionUseCase
    implements UseCase<void, ValidateSubscriptionRequest> {
  final SubscriptionRepository _repository;

  const ValidateSubscriptionUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(ValidateSubscriptionRequest params) async {
    await _repository.validateSubscription(
      params.userId,
    );
  }
}
