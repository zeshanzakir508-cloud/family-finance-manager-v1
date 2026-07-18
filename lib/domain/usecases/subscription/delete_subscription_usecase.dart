import '../../../repositories/subscription_repository.dart';
import '../../dto/subscription/delete_subscription_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class DeleteSubscriptionUseCase
    implements UseCase<void, DeleteSubscriptionRequest> {
  final SubscriptionRepository _repository;

  const DeleteSubscriptionUseCase({
    required SubscriptionRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteSubscriptionRequest params) async {
    final existing = await _repository.getSubscription(
      params.subscriptionId,
    );

    if (existing == null) {
      throw const NotFoundException(
        'Subscription not found.',
      );
    }

    await _repository.deleteSubscription(
      params.subscriptionId,
    );
  }
}
