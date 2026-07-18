import '../../../repositories/notification_repository.dart';
import '../../dto/notification/restore_notification_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class RestoreNotificationUseCase
    implements UseCase<void, RestoreNotificationRequest> {
  final NotificationRepository _repository;

  const RestoreNotificationUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RestoreNotificationRequest params,
  ) async {
    final exists = await _repository.notificationExists(
      params.notificationId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Notification not found.',
      );
    }

    await _repository.restoreNotification(
      params.notificationId,
    );
  }
}
