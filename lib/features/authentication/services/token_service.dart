import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/auth_constants.dart';

/// Service for managing authentication tokens.
class TokenService {
  final SharedPreferences _prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _tokenTimestampKey = 'token_timestamp';

  TokenService(this._prefs);

  /// Saves access token with expiry.
  Future<void> saveAccessToken({
    required String accessToken,
    Duration? expiresIn,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(
      _tokenExpiryKey,
      DateTime.now().add(expiresIn ?? AuthConstants.accessTokenExpiration).toIso8601String(),
    );
    await _prefs.setString(_tokenTimestampKey, DateTime.now().toIso8601String());
  }

  /// Gets the stored access token.
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  /// Gets the stored refresh token.
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  /// Saves refresh token.
  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Checks if the access token is expired.
  bool isAccessTokenExpired() {
    final expiryString = _prefs.getString(_tokenExpiryKey);
    if (expiryString == null) return true;

    try {
      final expiry = DateTime.parse(expiryString);
      return expiry.isBefore(DateTime.now());
    } catch (e) {
      return true;
    }
  }

  /// Checks if the access token is about to expire (within 5 minutes).
  bool isAccessTokenExpiringSoon() {
    final expiryString = _prefs.getString(_tokenExpiryKey);
    if (expiryString == null) return true;

    try {
      final expiry = DateTime.parse(expiryString);
      final warningTime = DateTime.now().add(const Duration(minutes: 5));
      return expiry.isBefore(warningTime);
    } catch (e) {
      return true;
    }
  }

  /// Gets the remaining time until token expiry.
  Duration getTokenRemainingTime() {
    final expiryString = _prefs.getString(_tokenExpiryKey);
    if (expiryString == null) return Duration.zero;

    try {
      final expiry = DateTime.parse(expiryString);
      final remaining = expiry.difference(DateTime.now());
      return remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      return Duration.zero;
    }
  }

  /// Clears all tokens.
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_tokenExpiryKey);
    await _prefs.remove(_tokenTimestampKey);
  }

  /// Decodes the JWT access token.
  Map<String, dynamic>? decodeAccessToken() {
    final token = getAccessToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Gets the user ID from the access token.
  String? getUserIdFromToken() {
    final decoded = decodeAccessToken();
    if (decoded == null) return null;

    return decoded['sub'] as String? ?? decoded['user_id'] as String?;
  }

  /// Gets the token expiry from the decoded token.
  DateTime? getTokenExpiryFromDecoded() {
    final decoded = decodeAccessToken();
    if (decoded == null) return null;

    final exp = decoded['exp'] as int?;
    if (exp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  /// Checks if all tokens exist.
  bool hasTokens() {
    return _prefs.containsKey(_accessTokenKey) &&
        _prefs.containsKey(_refreshTokenKey);
  }

  /// Refreshes the token by saving new ones.
  Future<void> refreshTokens({
    required String newAccessToken,
    String? newRefreshToken,
    Duration? expiresIn,
  }) async {
    await saveAccessToken(
      accessToken: newAccessToken,
      expiresIn: expiresIn,
    );

    if (newRefreshToken != null) {
      await saveRefreshToken(newRefreshToken);
    }
  }

  /// Returns token information as a map.
  Map<String, dynamic> getTokenInfo() {
    return {
      'hasAccessToken': _prefs.containsKey(_accessTokenKey),
      'hasRefreshToken': _prefs.containsKey(_refreshTokenKey),
      'isExpired': isAccessTokenExpired(),
      'isExpiringSoon': isAccessTokenExpiringSoon(),
      'remainingTime': getTokenRemainingTime().inSeconds,
      'userId': getUserIdFromToken(),
    };
  }
}
