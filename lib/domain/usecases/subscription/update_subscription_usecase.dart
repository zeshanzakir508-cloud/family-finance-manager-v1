import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/update_subscription_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/subscription_validator.dart';

class UpdateSubscriptionUseCase
    implements UseCase<void, UpdateSubscriptionRequest> {
  final SubscriptionRepository _repository;
  final SubscriptionValidator _validator;

  const UpdateSubscriptionUseCase({
    required SubscriptionRepository repository,
    required SubscriptionValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateSubscriptionRequest params) async {
    _validator.validate(params);

    final existing = await _repository.getSubscription(
      params.subscription.id,
    );

    if (existing == null) {
      throw const NotFoundException(
        'Subscription not found.',
      );
    }

    await _repository.updateSubscription(
      params.subscription,
    );
  }
}
