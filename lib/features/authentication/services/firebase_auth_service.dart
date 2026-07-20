import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'auth_service.dart';

/// Implementation of [AuthService] using Firebase Authentication.
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential?> login({
    required String? email,
    required String? password,
  }) async {
    if (email == null || password == null) return null;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateFcmToken();
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential?> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateFcmToken();
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  @override
  Future<void> applyActionCode(String code) async {
    await _auth.applyActionCode(code);
    // Reload user to refresh email verification status
    await _auth.currentUser?.reload();
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      // Firebase Auth doesn't have a direct token validation method
      // We can validate by checking if the token is expired
      // Or by attempting to get the current user
      final user = _auth.currentUser;
      if (user == null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> refreshToken(String refreshToken) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    try {
      return await user.getIdToken(true);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.delete();
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Re-authenticate first
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> sendOtpEmail(String email) async {
    // For email OTP, we use password reset flow with custom email
    // Or we can use Firebase's sendPasswordResetEmail
    await sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendPhoneOtp(String phoneNumber) async {
    // Firebase phone auth requires a PhoneAuthProvider
    // This is handled differently - typically using PhoneAuthProvider.verifyPhoneNumber
    // We'll throw an error if called directly
    throw UnsupportedError(
      'Phone OTP requires PhoneAuthProvider. Use PhoneAuthProvider.verifyPhoneNumber instead.',
    );
  }

  @override
  Future<bool> verifyOtp(String otp, String verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      return await _auth.fetchSignInMethodsForEmail(email);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  Future<void> _updateFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        // Store token in Firestore or send to backend
        // This is handled separately by the notification service
      }
    } catch (e) {
      // Ignore FCM token errors
    }
  }
}
