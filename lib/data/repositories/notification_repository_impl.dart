// lib/data/repositories/notification_repository_impl.dart

import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/notification.dart';
import '../../domain/exceptions/notification_exceptions.dart';
import '../datasources/remote/firestore_notification_data_source.dart';
import '../models/notification_model.dart';

/// Implementation of [NotificationRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class NotificationRepositoryImpl implements NotificationRepository {
  final FirestoreNotificationDataSource _remoteDataSource;

  const NotificationRepositoryImpl({
    required FirestoreNotificationDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on NotificationException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const NotificationDataException('Unexpected repository error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream repository operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on NotificationException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const NotificationDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Notification> getNotification(String notificationId) {
    return _execute(() async {
      final model = await _remoteDataSource.getNotification(notificationId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Notification>> getNotificationsByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getNotificationsByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Notification>> getNotificationsByUserIdAndStatus(
    String userId,
    NotificationStatus status,
  ) {
    return _execute(() async {
      final models = await _remoteDataSource.getNotificationsByUserIdAndStatus(
        userId,
        status,
      );
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Notification>> getUnreadNotificationsByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getUnreadNotificationsByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Notification>> getNotificationsByType(
    String userId,
    NotificationType type,
  ) {
    return _execute(() async {
      final models = await _remoteDataSource.getNotificationsByType(userId, type);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Notification>> getNotificationsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final models = await _remoteDataSource.getNotificationsByDateRange(
        userId,
        startDate,
        endDate,
      );
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Notification> createNotification(Notification notification) {
    return _execute(() async {
      final model = NotificationModel.fromDomain(notification);
      final createdModel = await _remoteDataSource.createNotification(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Notification> updateNotification(Notification notification) {
    return _execute(() async {
      final model = NotificationModel.fromDomain(notification);
      final updatedModel = await _remoteDataSource.updateNotification(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return _execute(() async {
      await _remoteDataSource.deleteNotification(notificationId);
    });
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _execute(() async {
      await _remoteDataSource.markAsRead(notificationId);
    });
  }

  @override
  Future<void> markAsUnread(String notificationId) {
    return _execute(() async {
      await _remoteDataSource.markAsUnread(notificationId);
    });
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _execute(() async {
      await _remoteDataSource.markAllAsRead(userId);
    });
  }

  @override
  Future<int> getUnreadCount(String userId) {
    return _execute(() async {
      return await _remoteDataSource.getUnreadCount(userId);
    });
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    return _execute(() async {
      await _remoteDataSource.sendNotification(
        userId: userId,
        title: title,
        body: body,
        type: type,
        data: data,
      );
    });
  }

  @override
  Future<void> sendBatchNotification({
    required List<String> userIds,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    return _execute(() async {
      await _remoteDataSource.sendBatchNotification(
        userIds: userIds,
        title: title,
        body: body,
        type: type,
        data: data,
      );
    });
  }

  @override
  Future<void> sendNotificationToFamily({
    required String familyId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    return _execute(() async {
      await _remoteDataSource.sendNotificationToFamily(
        familyId: familyId,
        title: title,
        body: body,
        type: type,
        data: data,
      );
    });
  }

  @override
  Stream<Notification> watchNotification(String notificationId) {
    return _executeStream(
      () => _remoteDataSource.watchNotification(notificationId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Notification>> watchNotificationsByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchNotificationsByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Notification>> watchUnreadNotificationsByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchUnreadNotificationsByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchUnreadCount(userId),
    );
  }
}
