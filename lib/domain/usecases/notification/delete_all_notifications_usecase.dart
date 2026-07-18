import '../../../repositories/notification_repository.dart';
import '../../dto/notification/delete_all_notifications_request.dart';
import '../../usecases/base_usecase.dart';

class DeleteAllNotificationsUseCase
    implements UseCase<void, DeleteAllNotificationsRequest> {
  final NotificationRepository _repository;

  const DeleteAllNotificationsUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    DeleteAllNotificationsRequest params,
  ) async {
    await _repository.deleteAllNotifications(
      params.userId,
    );
  }
}
