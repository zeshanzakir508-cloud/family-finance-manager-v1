import '../../../repositories/notification_repository.dart';
import '../../dto/notification/update_notification_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/notification_validator.dart';

class UpdateNotificationUseCase
    implements UseCase<void, UpdateNotificationRequest> {
  final NotificationRepository _repository;
  final NotificationValidator _validator;

  const UpdateNotificationUseCase({
    required NotificationRepository repository,
    required NotificationValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(UpdateNotificationRequest params) async {
    _validator.validate(params);

    final exists = await _repository.notificationExists(
      params.notification.id,
    );

    if (!exists) {
      throw const NotFoundException(
        'Notification not found.',
      );
    }

    await _repository.updateNotification(
      params.notification,
    );
  }
}
