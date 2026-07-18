import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/create_subscription_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/subscription_validator.dart';

class CreateSubscriptionUseCase
    implements UseCase<void, CreateSubscriptionRequest> {
  final SubscriptionRepository _repository;
  final SubscriptionValidator _validator;

  const CreateSubscriptionUseCase({
    required SubscriptionRepository repository,
    required SubscriptionValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateSubscriptionRequest params) async {
    _validator.validate(params);

    await _repository.createSubscription(
      params.subscription,
    );
  }
}
