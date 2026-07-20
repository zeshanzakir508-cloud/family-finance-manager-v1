import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/user_model.dart';
import '../enums/auth_status.dart';

/// Helper for managing authentication-related permissions.
class AuthPermissionHelper {
  AuthPermissionHelper._();

  /// Checks if the user has the required role.
  static bool hasRole(UserModel? user, String requiredRole) {
    if (user == null) return false;
    return user.role == requiredRole;
  }

  /// Checks if the user is an admin.
  static bool isAdmin(UserModel? user) {
    return hasRole(user, 'admin');
  }

  /// Checks if the user is a moderator.
  static bool isModerator(UserModel? user) {
    return hasRole(user, 'moderator') || isAdmin(user);
  }

  /// Checks if the user is a premium member.
  static bool isPremium(UserModel? user) {
    if (user == null) return false;
    return user.isPremium ?? false;
  }

  /// Checks if the user can access premium features.
  static bool canAccessPremium(UserModel? user) {
    return isPremium(user) || isAdmin(user);
  }

  /// Checks if the user has a verified email.
  static bool isEmailVerified(UserModel? user) {
    if (user == null) return false;
    return user.isEmailVerified ?? false;
  }

  /// Checks if the user account is active.
  static bool isAccountActive(UserModel? user) {
    if (user == null) return false;
    return user.isActive ?? false;
  }

  /// Checks if the user is fully authenticated.
  static bool isFullyAuthenticated(UserModel? user, AuthStatus status) {
    return status == AuthStatus.authenticated &&
        isAccountActive(user) &&
        isEmailVerified(user);
  }

  /// Checks if the user can perform write operations.
  static bool canWrite(UserModel? user) {
    if (user == null) return false;
    return isAccountActive(user) && isEmailVerified(user);
  }

  /// Checks if the user can delete data.
  static bool canDelete(UserModel? user) {
    return isAdmin(user) || isModerator(user);
  }

  /// Checks if the user can manage other users.
  static bool canManageUsers(UserModel? user) {
    return isAdmin(user);
  }

  /// Checks if the user can view reports.
  static bool canViewReports(UserModel? user) {
    return isAdmin(user) || isModerator(user) || isPremium(user);
  }

  /// Requests biometric permission.
  static Future<bool> requestBiometricPermission() async {
    final status = await Permission.biometric.request();
    return status.isGranted;
  }

  /// Checks biometric permission status.
  static Future<bool> checkBiometricPermission() async {
    final status = await Permission.biometric.status;
    return status.isGranted;
  }

  /// Requests camera permission.
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Requests storage permission.
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Requests notification permission.
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Checks if a specific permission is granted.
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Requests multiple permissions.
  static Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Returns true if all permissions are granted.
  static Future<bool> areAllPermissionsGranted(
    List<Permission> permissions,
  ) async {
    final statuses = await Future.wait(
      permissions.map((p) => p.status),
    );
    return statuses.every((s) => s.isGranted);
  }

  /// Opens app settings for permission management.
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Shows a permission denied dialog.
  static Future<bool> showPermissionDeniedDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
