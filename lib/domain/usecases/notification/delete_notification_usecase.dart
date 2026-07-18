import '../../../repositories/notification_repository.dart';
import '../../dto/notification/delete_notification_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

class DeleteNotificationUseCase
    implements UseCase<void, DeleteNotificationRequest> {
  final NotificationRepository _repository;

  const DeleteNotificationUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(DeleteNotificationRequest params) async {
    final exists = await _repository.notificationExists(
      params.notificationId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Notification not found.',
      );
    }

    await _repository.deleteNotification(
      params.notificationId,
    );
  }
}
