import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/auth_result.dart';
import '../models/auth_session_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/password_reset_model.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verification_model.dart';
import '../models/email_verification_model.dart';
import 'auth_repository.dart';
import '../../../models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../services/session_service.dart';
import '../services/remember_me_service.dart';
import '../constants/auth_constants.dart';

/// Implementation of [AuthRepository] using Firebase.
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final SessionService _sessionService;
  final RememberMeService _rememberMeService;

  AuthRepositoryImpl({
    required AuthService authService,
    required FirestoreService firestoreService,
    required SessionService sessionService,
    required RememberMeService rememberMeService,
  }) : _authService = authService,
       _firestoreService = firestoreService,
       _sessionService = sessionService,
       _rememberMeService = rememberMeService;

  @override
  Future<Either<AuthResult, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      // Authenticate with Firebase
      final result = await _authService.login(
        email: request.email,
        password: request.password,
      );

      if (result == null) {
        return const Left(AuthResult.invalidCredentials);
      }

      final user = result.user;
      if (user == null) {
        return const Left(AuthResult.userNotFound);
      }

      // Check if email is verified
      if (!user.emailVerified) {
        return const Left(AuthResult.emailNotVerified);
      }

      // Get user profile from Firestore
      final userModel = await _getUserModel(user.uid);
      if (userModel == null) {
        return const Left(AuthResult.unknown);
      }

      // Check if user is blocked
      if (!userModel.isActive) {
        return const Left(AuthResult.accountBlocked);
      }

      // Create session
      final session = AuthSessionModel.newSession(
        userId: user.uid,
        accessToken: await user.getIdToken() ?? '',
        refreshToken: result.refreshToken,
      );

      // Save session
      await _sessionService.saveSession(session);

      // Save remember me if enabled
      if (request.rememberMe) {
        await _rememberMeService.saveCredentials(
          email: request.email!,
          password: request.password!,
          userId: user.uid,
        );
      }

      // Update last login
      await _firestoreService.updateDocument(
        'users',
        user.uid,
        {'lastLoginAt': FieldValue.serverTimestamp()},
      );

      return Right(
        LoginResponseModel(
          userId: user.uid,
          email: user.email,
          displayName: userModel.displayName,
          session: session,
          isEmailVerified: user.emailVerified,
          isActive: userModel.isActive,
          createdAt: userModel.createdAt,
          lastLoginAt: userModel.lastLoginAt,
          role: userModel.role,
          photoUrl: userModel.photoUrl,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, LoginResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      // Create user in Firebase Auth
      final result = await _authService.register(
        email: request.email,
        password: request.password,
      );

      if (result == null) {
        return const Left(AuthResult.registerFailed);
      }

      final user = result.user;
      if (user == null) {
        return const Left(AuthResult.registerFailed);
      }

      // Create user profile in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: request.email,
        displayName: request.displayName ?? '',
        phone: request.phone,
        username: request.username,
        isEmailVerified: false,
        isActive: true,
        createdAt: DateTime.now(),
        role: 'user',
      );

      await _firestoreService.setDocument(
        'users',
        user.uid,
        userModel.toJson(),
      );

      // Send email verification
      await _authService.sendEmailVerification();

      // Create session
      final session = AuthSessionModel.newSession(
        userId: user.uid,
        accessToken: await user.getIdToken() ?? '',
        refreshToken: result.refreshToken,
      );

      await _sessionService.saveSession(session);

      return Right(
        LoginResponseModel(
          userId: user.uid,
          email: user.email,
          displayName: userModel.displayName,
          session: session,
          isEmailVerified: false,
          isActive: true,
          createdAt: userModel.createdAt,
          role: userModel.role,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> logout() async {
    try {
      await _authService.logout();
      await _sessionService.clearSession();
      return const Right(null);
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, UserModel>> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthResult.userNotFound);
      }

      final userModel = await _getUserModel(firebaseUser.uid);
      if (userModel == null) {
        return const Left(AuthResult.userNotFound);
      }

      return Right(userModel);
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _getUserModel(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> validateSession(AuthSessionModel session) async {
    try {
      if (session.isExpired) return false;
      // Validate token with Firebase
      final isValid = await _authService.validateToken(session.accessToken);
      return isValid;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<AuthResult, AuthSessionModel>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final newToken = await _authService.refreshToken(refreshToken);
      if (newToken == null) {
        return const Left(AuthResult.sessionExpired);
      }

      final user = _authService.currentUser;
      if (user == null) {
        return const Left(AuthResult.userNotFound);
      }

      final session = AuthSessionModel.newSession(
        userId: user.uid,
        accessToken: newToken,
        refreshToken: refreshToken,
      );

      await _sessionService.saveSession(session);

      return Right(session);
    } catch (e) {
      return const Left(AuthResult.sessionExpired);
    }
  }

  @override
  Future<Either<AuthResult, void>> sendPasswordResetEmail(
    PasswordResetModel request,
  ) async {
    try {
      await _authService.sendPasswordResetEmail(request.email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> resetPassword(
    PasswordResetModel request,
  ) async {
    try {
      await _authService.confirmPasswordReset(
        request.token!,
        request.newPassword!,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> sendEmailVerification(
    EmailVerificationModel request,
  ) async {
    try {
      await _authService.sendEmailVerification();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> verifyEmail(
    EmailVerificationModel request,
  ) async {
    try {
      if (request.isTokenVerification) {
        await _authService.applyActionCode(request.token!);
        return const Right(null);
      }
      return const Left(AuthResult.invalidOtp);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> requestOtp(
    OtpRequestModel request,
  ) async {
    try {
      // For email OTP
      if (request.hasEmail) {
        // Send OTP via email
        await _authService.sendOtpEmail(request.email!);
        return const Right(null);
      }

      // For phone OTP
      if (request.hasPhone) {
        await _authService.sendPhoneOtp(request.phone!);
        return const Right(null);
      }

      return const Left(AuthResult.unknown);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> verifyOtp(
    OtpVerificationModel request,
  ) async {
    try {
      // Verify OTP
      final isValid = await _authService.verifyOtp(
        request.otp,
        request.email ?? request.phone ?? '',
      );

      if (!isValid) {
        return const Left(AuthResult.invalidOtp);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> deleteAccount() async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        return const Left(AuthResult.userNotFound);
      }

      // Delete user data from Firestore
      await _firestoreService.deleteDocument('users', user.uid);

      // Delete authentication account
      await _authService.deleteAccount();

      await _sessionService.clearSession();
      await _rememberMeService.clearCredentials();

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, LoginResponseModel>> autoLogin() async {
    try {
      final credentials = await _rememberMeService.getCredentials();

      if (credentials == null) {
        return const Left(AuthResult.userNotFound);
      }

      // Auto login with stored credentials
      final loginRequest = LoginRequestModel.emailPassword(
        email: credentials.email,
        password: credentials.encryptedPassword ?? '',
        rememberMe: true,
      );

      return await login(loginRequest);
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<bool> isUserBlocked(String userId) async {
    try {
      final user = await _getUserModel(userId);
      return user != null && !user.isActive;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<AuthResult, UserModel>> updateProfile(
    UserModel user,
  ) async {
    try {
      await _firestoreService.updateDocument(
        'users',
        user.id,
        user.toJson(),
      );
      return Right(user);
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<Either<AuthResult, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(currentPassword, newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return const Left(AuthResult.unknown);
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final result = await _authService.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  Future<UserModel?> _getUserModel(String userId) async {
    try {
      final doc = await _firestoreService.getDocument('users', userId);
      if (doc == null || !doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  AuthResult _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthResult.userNotFound;
      case 'wrong-password':
        return AuthResult.wrongPassword;
      case 'email-already-in-use':
        return AuthResult.emailAlreadyInUse;
      case 'invalid-email':
        return AuthResult.invalidCredentials;
      case 'too-many-requests':
        return AuthResult.tooManyRequests;
      case 'network-request-failed':
        return AuthResult.networkError;
      case 'user-disabled':
        return AuthResult.accountDisabled;
      case 'requires-recent-login':
        return AuthResult.sessionExpired;
      default:
        return AuthResult.unknown;
    }
  }
}
