import '../../../repositories/notification_repository.dart';
import '../../dto/notification/mark_as_read_request.dart';
import '../../usecases/base_usecase.dart';

class MarkAsReadUseCase
    implements UseCase<void, MarkAsReadRequest> {
  final NotificationRepository _repository;

  const MarkAsReadUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(MarkAsReadRequest params) async {
    await _repository.markAsRead(
      params.notificationId,
    );
  }
}
