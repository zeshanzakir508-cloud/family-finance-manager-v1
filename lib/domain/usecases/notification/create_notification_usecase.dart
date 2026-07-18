import '../../../repositories/notification_repository.dart';
import '../../dto/notification/create_notification_request.dart';
import '../../usecases/base_usecase.dart';
import '../../validators/notification_validator.dart';

class CreateNotificationUseCase
    implements UseCase<void, CreateNotificationRequest> {
  final NotificationRepository _repository;
  final NotificationValidator _validator;

  const CreateNotificationUseCase({
    required NotificationRepository repository,
    required NotificationValidator validator,
  })  : _repository = repository,
        _validator = validator;

  @override
  Future<void> call(CreateNotificationRequest params) async {
    _validator.validate(params);

    await _repository.createNotification(
      params.notification,
    );
  }
}
