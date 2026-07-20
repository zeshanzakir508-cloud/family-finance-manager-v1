import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../enums/auth_result.dart';
import '../enums/otp_type.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verification_model.dart';
import 'auth_controller.dart';
import '../constants/auth_constants.dart';

/// OTP controller state.
class OtpState {
  final String otpCode;
  final String email;
  final String phone;
  final OtpType otpType;
  final bool isLoading;
  final bool isVerified;
  final bool canResend;
  final int resendCount;
  final int remainingSeconds;
  final String? error;
  final bool isValid;

  const OtpState({
    this.otpCode = '',
    this.email = '',
    this.phone = '',
    this.otpType = OtpType.emailVerification,
    this.isLoading = false,
    this.isVerified = false,
    this.canResend = true,
    this.resendCount = 0,
    this.remainingSeconds = AuthConstants.otpExpirationDuration.inSeconds ~/ 2,
    this.error,
    this.isValid = false,
  });

  OtpState copyWith({
    String? otpCode,
    String? email,
    String? phone,
    OtpType? otpType,
    bool? isLoading,
    bool? isVerified,
    bool? canResend,
    int? resendCount,
    int? remainingSeconds,
    String? error,
    bool? isValid,
  }) {
    return OtpState(
      otpCode: otpCode ?? this.otpCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otpType: otpType ?? this.otpType,
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      canResend: canResend ?? this.canResend,
      resendCount: resendCount ?? this.resendCount,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
    );
  }

  bool get hasEmail => email.isNotEmpty;
  bool get hasPhone => phone.isNotEmpty;
  bool get isOtpComplete => otpCode.length == 6;
}

/// OTP controller notifier.
class OtpController extends StateNotifier<OtpState> {
  final AuthController _authController;

  OtpController(this._authController) : super(const OtpState());

  /// Initializes OTP with email.
  void initializeWithEmail({
    required String email,
    OtpType type = OtpType.emailVerification,
  }) {
    state = state.copyWith(
      email: email,
      otpType: type,
      phone: '',
      otpCode: '',
      error: null,
      isVerified: false,
    );
    _updateValidity();
  }

  /// Initializes OTP with phone.
  void initializeWithPhone({
    required String phone,
    OtpType type = OtpType.phoneVerification,
  }) {
    state = state.copyWith(
      phone: phone,
      otpType: type,
      email: '',
      otpCode: '',
      error: null,
      isVerified: false,
    );
    _updateValidity();
  }

  /// Updates OTP code field.
  void updateOtp(String otp) {
    final sanitized = otp.replaceAll(RegExp(r'[^0-9]'), '');
    final truncated = sanitized.length <= 6 ? sanitized : sanitized.substring(0, 6);
    state = state.copyWith(
      otpCode: truncated,
      error: null,
    );
    _updateValidity();
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Verifies the OTP.
  Future<Either<AuthResult, void>> verifyOtp() async {
    if (!state.isOtpComplete) {
      return const Left(AuthResult.invalidOtp);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = OtpVerificationModel(
        email: state.hasEmail ? state.email : null,
        phone: state.hasPhone ? state.phone : null,
        otp: state.otpCode,
        type: state.otpType,
      );

      final result = await _authController.verifyOtp(request);

      return result.fold(
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(error),
          );
          return Left(error);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            isVerified: true,
            error: null,
          );
          return Right(success);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      return const Left(AuthResult.unknown);
    }
  }

  /// Resends the OTP.
  Future<Either<AuthResult, void>> resendOtp() async {
    if (!state.canResend) {
      return const Left(AuthResult.tooManyRequests);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = OtpRequestModel(
        email: state.hasEmail ? state.email : null,
        phone: state.hasPhone ? state.phone : null,
        type: state.otpType,
      );

      final result = await _authController.requestOtp(request);

      return result.fold(
        (error) {
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(error),
          );
          return Left(error);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            canResend: false,
            resendCount: state.resendCount + 1,
            remainingSeconds: AuthConstants.otpExpirationDuration.inSeconds ~/ 2,
            otpCode: '',
            error: null,
          );
          _startTimer();
          return Right(success);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      return const Left(AuthResult.unknown);
    }
  }

  /// Starts the resend timer.
  void _startTimer() {
    // This will be called from the UI using a Timer
  }

  /// Updates remaining seconds (called by UI timer).
  void updateRemainingSeconds(int seconds) {
    state = state.copyWith(remainingSeconds: seconds);
    if (seconds <= 0) {
      state = state.copyWith(canResend: true);
    }
  }

  /// Resets the OTP state.
  void reset() {
    state = const OtpState();
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  void _updateValidity() {
    state = state.copyWith(
      isValid: state.isOtpComplete,
    );
  }

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.invalidOtp:
        return 'Invalid OTP. Please check and try again.';
      case AuthResult.otpExpired:
        return 'OTP has expired. Please request a new one.';
      case AuthResult.tooManyRequests:
        return 'Too many attempts. Please wait before trying again.';
      case AuthResult.networkError:
        return 'Network error. Please check your connection.';
      default:
        return 'OTP verification failed. Please try again.';
    }
  }
}

/// Provider for OtpController.
final otpControllerProvider = StateNotifierProvider<OtpController, OtpState>((ref) {
  final authController = ref.watch(authControllerProvider);
  return OtpController(authController);
});
