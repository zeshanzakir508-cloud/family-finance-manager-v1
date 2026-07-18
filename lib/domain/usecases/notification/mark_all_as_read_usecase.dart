import '../../../repositories/notification_repository.dart';
import '../../dto/notification/mark_all_as_read_request.dart';
import '../../usecases/base_usecase.dart';

class MarkAllAsReadUseCase
    implements UseCase<void, MarkAllAsReadRequest> {
  final NotificationRepository _repository;

  const MarkAllAsReadUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    MarkAllAsReadRequest params,
  ) async {
    await _repository.markAllAsRead(
      params.userId,
    );
  }
}
