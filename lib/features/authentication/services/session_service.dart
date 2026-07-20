import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_session_model.dart';
import '../constants/auth_constants.dart';

/// Service for managing authentication sessions.
class SessionService {
  static const String _sessionKey = 'auth_session';
  static const String _sessionTimestampKey = 'auth_session_timestamp';

  final SharedPreferences _prefs;

  SessionService(this._prefs);

  /// Saves the session to shared preferences.
  Future<void> saveSession(AuthSessionModel session) async {
    final json = jsonEncode({
      'userId': session.userId,
      'accessToken': session.accessToken,
      'refreshToken': session.refreshToken,
      'expiresAt': session.expiresAt.toIso8601String(),
      'createdAt': session.createdAt.toIso8601String(),
      'sessionId': session.sessionId,
      'deviceId': session.deviceId,
      'isActive': session.isActive,
    });

    await _prefs.setString(_sessionKey, json);
    await _prefs.setString(_sessionTimestampKey, DateTime.now().toIso8601String());
  }

  /// Restores the session from shared preferences.
  Future<AuthSessionModel?> restoreSession() async {
    final jsonString = _prefs.getString(_sessionKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Check if session is expired
      final expiresAt = DateTime.parse(json['expiresAt'] as String);
      if (expiresAt.isBefore(DateTime.now())) {
        await clearSession();
        return null;
      }

      return AuthSessionModel(
        userId: json['userId'] as String,
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String?,
        expiresAt: expiresAt,
        createdAt: DateTime.parse(json['createdAt'] as String),
        sessionId: json['sessionId'] as String?,
        deviceId: json['deviceId'] as String?,
        isActive: json['isActive'] as bool? ?? true,
      );
    } catch (e) {
      await clearSession();
      return null;
    }
  }

  /// Clears the session from shared preferences.
  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
    await _prefs.remove(_sessionTimestampKey);
  }

  /// Returns true if a session exists.
  Future<bool> hasSession() async {
    return _prefs.containsKey(_sessionKey);
  }

  /// Returns the session creation timestamp.
  Future<DateTime?> getSessionTimestamp() async {
    final timestamp = _prefs.getString(_sessionTimestampKey);
    if (timestamp == null) return null;
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Returns the session age.
  Future<Duration?> getSessionAge() async {
    final timestamp = await getSessionTimestamp();
    if (timestamp == null) return null;
    return DateTime.now().difference(timestamp);
  }

  /// Updates the session with new tokens.
  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
    Duration? expiresIn,
  }) async {
    final current = await restoreSession();
    if (current == null) return;

    final updated = current.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken ?? current.refreshToken,
      expiresAt: expiresIn != null
          ? DateTime.now().add(expiresIn)
          : DateTime.now().add(AuthConstants.accessTokenExpiration),
    );

    await saveSession(updated);
  }

  /// Checks if the session is expired.
  Future<bool> isSessionExpired() async {
    final session = await restoreSession();
    if (session == null) return true;
    return session.isExpired;
  }

  /// Checks if the session is about to expire (within 5 minutes).
  Future<bool> isSessionExpiringSoon() async {
    final session = await restoreSession();
    if (session == null) return true;
    return session.isExpiringSoon;
  }
}
