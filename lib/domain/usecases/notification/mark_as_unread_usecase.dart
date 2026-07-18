import '../../../repositories/notification_repository.dart';
import '../../dto/notification/mark_as_unread_request.dart';
import '../../usecases/base_usecase.dart';

class MarkAsUnreadUseCase
    implements UseCase<void, MarkAsUnreadRequest> {
  final NotificationRepository _repository;

  const MarkAsUnreadUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(MarkAsUnreadRequest params) async {
    await _repository.markAsUnread(
      params.notificationId,
    );
  }
}
