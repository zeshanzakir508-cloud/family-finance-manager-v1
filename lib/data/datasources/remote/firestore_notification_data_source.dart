// lib/data/datasources/remote/firestore_notification_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/notification_exceptions.dart';
import '../../models/notification_model.dart';

/// Data source for Firestore Notification operations.
///
/// This class handles all direct communication with Firestore for notification-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for notifications.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreNotificationDataSource {
  final FirebaseFirestore _firestore;

  FirestoreNotificationDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for notifications.
  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  /// Document reference for a specific notification.
  DocumentReference<Map<String, dynamic>> _notificationDocument(String notificationId) =>
      _notificationsCollection.doc(notificationId);

  /// Executes a Firestore operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const NotificationDataException('Unexpected notification data source error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream Firestore operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const NotificationDataException('Unexpected notification stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain NotificationException.
  NotificationException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const NotificationDataException('Permission denied to access notification data.');
      case 'not-found':
        return const NotificationNotFoundException('Notification not found.');
      case 'already-exists':
        return const NotificationDataException('Notification already exists.');
      case 'failed-precondition':
        return const NotificationDataException('Precondition failed for notification operation.');
      case 'aborted':
        return const NotificationDataException('Notification operation was aborted.');
      case 'out-of-range':
        return const NotificationDataException('Notification operation out of range.');
      case 'unimplemented':
        return const NotificationDataException('Notification operation not implemented.');
      case 'internal':
        return const NotificationDataException('Internal error accessing notification data.');
      case 'unavailable':
        return const NotificationDataException('Notification service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const NotificationDataException('Notification operation timed out.');
      default:
        return NotificationDataException('Notification error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firestore DocumentSnapshot to NotificationModel.
  NotificationModel _documentToModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const NotificationDataException('Notification document data is null.');
    }

    final readAt = (data['readAt'] as Timestamp?)?.toDate();

    return NotificationModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: data['type'] as String? ?? 'system',
      isRead: data['isRead'] as bool? ?? false,
      readAt: readAt,
      data: (data['data'] as Map<String, dynamic>?) ?? {},
      imageUrl: data['imageUrl'] as String?,
      actionUrl: data['actionUrl'] as String?,
      senderId: data['senderId'] as String?,
      senderName: data['senderName'] as String?,
      familyId: data['familyId'] as String?,
      priority: data['priority'] as String? ?? 'normal',
      category: data['category'] as String?,
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts NotificationModel to Firestore map for creation.
  Map<String, dynamic> _modelToCreateMap(NotificationModel model) {
    return {
      'userId': model.userId,
      'title': model.title,
      'body': model.body,
      'type': model.type,
      'isRead': model.isRead,
      'data': model.data,
      'imageUrl': model.imageUrl,
      'actionUrl': model.actionUrl,
      'senderId': model.senderId,
      'senderName': model.senderName,
      'familyId': model.familyId,
      'priority': model.priority,
      'category': model.category,
      'expiresAt': model.expiresAt,
    };
  }

  /// Converts NotificationModel to Firestore map for updates.
  Map<String, dynamic> _modelToUpdateMap(NotificationModel model, {bool includeNulls = false}) {
    final map = <String, dynamic>{
      'title': model.title,
      'body': model.body,
      'type': model.type,
      'isRead': model.isRead,
      'data': model.data,
      'priority': model.priority,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Helper to add field with null handling
    void addField(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      } else if (includeNulls) {
        map[key] = FieldValue.delete();
      }
    }

    addField('imageUrl', model.imageUrl);
    addField('actionUrl', model.actionUrl);
    addField('senderId', model.senderId);
    addField('senderName', model.senderName);
    addField('familyId', model.familyId);
    addField('category', model.category);
    addField('expiresAt', model.expiresAt);

    return map;
  }

  /// Creates a map for creating a new notification with server timestamps.
  Map<String, dynamic> _createNotificationWithTimestamps(NotificationModel model) {
    return {
      ..._modelToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Creates a map for marking a notification as read.
  Map<String, dynamic> _markAsReadMap() {
    return {
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Internal method to create a notification without wrapping in _execute.
  Future<NotificationModel> _createNotificationInternal(NotificationModel notification) async {
    final docRef = _notificationsCollection.doc();
    final newNotification = notification.copyWith(
      id: docRef.id,
      isRead: false,
    );

    await docRef.set(_createNotificationWithTimestamps(newNotification));

    final doc = await docRef.get();
    return _documentToModel(doc);
  }

  /// Executes a batch operation with chunking to handle Firestore's 500-operation limit.
  Future<void> _executeBatched(
    List<DocumentReference<Map<String, dynamic>>> refs,
    void Function(WriteBatch batch, DocumentReference<Map<String, dynamic>> ref) operation,
  ) async {
    const chunkSize = 500;

    for (var i = 0; i < refs.length; i += chunkSize) {
      final end = (i + chunkSize < refs.length) ? i + chunkSize : refs.length;
      final chunk = refs.sublist(i, end);

      final batch = _firestore.batch();
      for (final ref in chunk) {
        operation(batch, ref);
      }
      await batch.commit();
    }
  }

  // ==================== Read Operations ====================

  /// Gets a notification by ID.
  Future<NotificationModel> getNotification(String notificationId) {
    return _execute(() async {
      final doc = await _notificationDocument(notificationId).get();
      if (!doc.exists) {
        throw const NotificationNotFoundException('Notification not found.');
      }
      return _documentToModel(doc);
    });
  }

  /// Gets all notifications for a user.
  Future<List<NotificationModel>> getNotificationsByUserId(String userId) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets notifications by user and status.
  Future<List<NotificationModel>> getNotificationsByUserIdAndStatus(
    String userId,
    String status,
  ) {
    return _execute(() async {
      final isRead = status == 'read';
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: isRead)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets unread notifications for a user.
  Future<List<NotificationModel>> getUnreadNotificationsByUserId(String userId) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets notifications by type for a user.
  Future<List<NotificationModel>> getNotificationsByType(
    String userId,
    String type,
  ) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets notifications by date range for a user.
  Future<List<NotificationModel>> getNotificationsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets notifications by family ID.
  Future<List<NotificationModel>> getNotificationsByFamilyId(String familyId) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('familyId', isEqualTo: familyId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets notifications by priority.
  Future<List<NotificationModel>> getNotificationsByPriority(
    String userId,
    String priority,
  ) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('priority', isEqualTo: priority)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets recent notifications for a user.
  Future<List<NotificationModel>> getRecentNotifications(
    String userId,
    int limit,
  ) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  // ==================== Write Operations ====================

  /// Creates a new notification.
  Future<NotificationModel> createNotification(NotificationModel notification) {
    return _execute(() async {
      return await _createNotificationInternal(notification);
    });
  }

  /// Updates an existing notification.
  Future<NotificationModel> updateNotification(
    NotificationModel notification, {
    bool clearNullFields = false,
  }) {
    return _execute(() async {
      final docRef = _notificationDocument(notification.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const NotificationNotFoundException('Notification not found.');
      }

      await docRef.update(_modelToUpdateMap(notification, includeNulls: clearNullFields));

      final updatedDoc = await docRef.get();
      return _documentToModel(updatedDoc);
    });
  }

  /// Deletes a notification.
  Future<void> deleteNotification(String notificationId) {
    return _execute(() async {
      final docRef = _notificationDocument(notificationId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const NotificationNotFoundException('Notification not found.');
      }

      await docRef.delete();
    });
  }

  /// Marks a notification as read.
  Future<void> markAsRead(String notificationId) {
    return _execute(() async {
      final docRef = _notificationDocument(notificationId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const NotificationNotFoundException('Notification not found.');
      }

      await docRef.update(_markAsReadMap());
    });
  }

  /// Marks a notification as unread.
  Future<void> markAsUnread(String notificationId) {
    return _execute(() async {
      final docRef = _notificationDocument(notificationId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const NotificationNotFoundException('Notification not found.');
      }

      await docRef.update({
        'isRead': false,
        'readAt': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Marks all notifications for a user as read.
  Future<void> markAllAsRead(String userId) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      if (query.docs.isEmpty) {
        return;
      }

      final refs = query.docs.map((doc) => doc.reference).toList();
      final updateData = _markAsReadMap();

      await _executeBatched(
        refs,
        (batch, ref) => batch.update(ref, updateData),
      );
    });
  }

  /// Deletes all notifications for a user (older than optional date).
  Future<void> deleteAllNotifications(
    String userId, {
    DateTime? olderThan,
  }) {
    return _execute(() async {
      var query = _notificationsCollection.where('userId', isEqualTo: userId);

      if (olderThan != null) {
        query = query.where('createdAt', isLessThan: olderThan);
      }

      final result = await query.get();

      if (result.docs.isEmpty) {
        return;
      }

      final refs = result.docs.map((doc) => doc.reference).toList();

      await _executeBatched(
        refs,
        (batch, ref) => batch.delete(ref),
      );
    });
  }

  /// Deletes read notifications for a user older than a date.
  Future<void> deleteReadNotificationsOlderThan(
    String userId,
    DateTime olderThan,
  ) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: true)
          .where('createdAt', isLessThan: olderThan)
          .get();

      if (query.docs.isEmpty) {
        return;
      }

      final refs = query.docs.map((doc) => doc.reference).toList();

      await _executeBatched(
        refs,
        (batch, ref) => batch.delete(ref),
      );
    });
  }

  /// Sends a notification (creates and optionally handles push).
  Future<NotificationModel> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? senderId,
    String? senderName,
    String? familyId,
    String? priority,
    String? category,
    DateTime? expiresAt,
  }) {
    return _execute(() async {
      final notification = NotificationModel(
        id: '',
        userId: userId,
        title: title,
        body: body,
        type: type,
        isRead: false,
        data: data ?? {},
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        senderId: senderId,
        senderName: senderName,
        familyId: familyId,
        priority: priority ?? 'normal',
        category: category,
        expiresAt: expiresAt,
      );

      return await _createNotificationInternal(notification);
    });
  }

  /// Sends batch notifications to multiple users.
  Future<List<NotificationModel>> sendBatchNotification({
    required List<String> userIds,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? senderId,
    String? senderName,
    String? familyId,
    String? priority,
    String? category,
    DateTime? expiresAt,
  }) {
    return _execute(() async {
      final notifications = <NotificationModel>[];
      final refs = <DocumentReference<Map<String, dynamic>>>[];

      for (final userId in userIds) {
        final docRef = _notificationsCollection.doc();
        final notification = NotificationModel(
          id: docRef.id,
          userId: userId,
          title: title,
          body: body,
          type: type,
          isRead: false,
          data: data ?? {},
          imageUrl: imageUrl,
          actionUrl: actionUrl,
          senderId: senderId,
          senderName: senderName,
          familyId: familyId,
          priority: priority ?? 'normal',
          category: category,
          expiresAt: expiresAt,
        );

        notifications.add(notification);
        refs.add(docRef);
      }

      // Chunk the batch creation
      const chunkSize = 500;
      for (var i = 0; i < refs.length; i += chunkSize) {
        final end = (i + chunkSize < refs.length) ? i + chunkSize : refs.length;
        final chunk = refs.sublist(i, end);

        final batch = _firestore.batch();
        for (var j = 0; j < chunk.length; j++) {
          final ref = chunk[j];
          final notification = notifications[i + j];
          final newNotification = notification.copyWith(id: ref.id);
          batch.set(ref, _createNotificationWithTimestamps(newNotification));
        }
        await batch.commit();
      }

      // Fetch the created notifications with server timestamps
      final fetchedNotifications = <NotificationModel>[];
      for (final ref in refs) {
        final doc = await ref.get();
        fetchedNotifications.add(_documentToModel(doc));
      }

      return fetchedNotifications;
    });
  }

  /// Sends a notification to all members of a family.
  Future<List<NotificationModel>> sendNotificationToFamily({
    required String familyId,
    required String title,
    required String body,
    required String type,
    List<String>? excludeUserIds,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? senderId,
    String? senderName,
    String? priority,
    String? category,
    DateTime? expiresAt,
  }) {
    return _execute(() async {
      final membersQuery = await _firestore
          .collection('familyMembers')
          .where('familyId', isEqualTo: familyId)
          .where('isActive', isEqualTo: true)
          .get();

      if (membersQuery.docs.isEmpty) {
        return <NotificationModel>[];
      }

      final userIds = membersQuery.docs
          .map((doc) => doc.data()['userId'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .where((id) => !(excludeUserIds?.contains(id) ?? false))
          .toList();

      if (userIds.isEmpty) {
        return <NotificationModel>[];
      }

      return await sendBatchNotification(
        userIds: userIds,
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        senderId: senderId,
        senderName: senderName,
        familyId: familyId,
        priority: priority,
        category: category,
        expiresAt: expiresAt,
      );
    });
  }

  /// Gets the unread count for a user.
  Future<int> getUnreadCount(String userId) {
    return _execute(() async {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return query.count;
    });
  }

  // ==================== Stream Operations ====================

  /// Watches a notification in real-time.
  Stream<NotificationModel> watchNotification(String notificationId) {
    return _executeStream(
      () => _notificationDocument(notificationId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const NotificationNotFoundException('Notification not found.');
        }
        return _documentToModel(doc);
      }),
    );
  }

  /// Watches all notifications for a user in real-time.
  Stream<List<NotificationModel>> watchNotificationsByUserId(String userId) {
    return _executeStream(
      () => _notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches unread notifications for a user in real-time.
  Stream<List<NotificationModel>> watchUnreadNotificationsByUserId(String userId) {
    return _executeStream(
      () => _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches the unread count for a user in real-time.
  Stream<int> watchUnreadCount(String userId) {
    return _executeStream(
      () => _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((query) => query.docs.length),
    );
  }

  /// Watches notifications by type for a user in real-time.
  Stream<List<NotificationModel>> watchNotificationsByType(
    String userId,
    String type,
  ) {
    return _executeStream(
      () => _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches notifications by family in real-time.
  Stream<List<NotificationModel>> watchNotificationsByFamilyId(String familyId) {
    return _executeStream(
      () => _notificationsCollection
          .where('familyId', isEqualTo: familyId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }
}
