import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

/// ============================================================================
/// Family Finance Manager
/// Notification Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Firebase Cloud Messaging (FCM).
///
/// Responsibilities:
/// • Request notification permission
/// • Get FCM token
/// • Refresh FCM token
/// • Subscribe/Unsubscribe topics
/// • Foreground message stream
/// • Background notification support
///
/// NOTE:
/// This service only wraps Firebase Messaging.
/// Local notification display and business logic belong elsewhere.
/// ============================================================================
class NotificationService {
  NotificationService({
    required FirebaseMessaging messaging,
  }) : _messaging = messaging;

  final FirebaseMessaging _messaging;

  StreamSubscription<String>? _tokenSubscription;

  /// Requests notification permission.
  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Returns the current FCM token.
  Future<String?> getToken() {
    return _messaging.getToken();
  }

  /// Deletes the current FCM token.
  Future<void> deleteToken() {
    return _messaging.deleteToken();
  }

  /// Listens for token refresh.
  void listenTokenRefresh(
    Future<void> Function(String token) onTokenRefresh,
  ) {
    _tokenSubscription?.cancel();

    _tokenSubscription =
        _messaging.onTokenRefresh.listen((token) async {
      await onTokenRefresh(token);
    });
  }

  /// Stream of foreground messages.
  Stream<RemoteMessage> get onMessage =>
      FirebaseMessaging.onMessage;

  /// Stream fired when a notification is tapped.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Returns the notification responsible for opening the app,
  /// if the app was launched from a terminated state.
  Future<RemoteMessage?> getInitialMessage() {
    return _messaging.getInitialMessage();
  }

  /// Subscribes to a topic.
  Future<void> subscribeToTopic(
    String topic,
  ) {
    return _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribes from a topic.
  Future<void> unsubscribeFromTopic(
    String topic,
  ) {
    return _messaging.unsubscribeFromTopic(topic);
  }

  /// Enables automatic Firebase Messaging initialization.
  Future<void> enableAutoInit() {
    return _messaging.setAutoInitEnabled(true);
  }

  /// Disables automatic Firebase Messaging initialization.
  Future<void> disableAutoInit() {
    return _messaging.setAutoInitEnabled(false);
  }

  /// Releases resources.
  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }
}
