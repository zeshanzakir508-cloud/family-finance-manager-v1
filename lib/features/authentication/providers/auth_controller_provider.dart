import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/controllers/auth_controller.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../services/session_service.dart';
import '../services/remember_me_service.dart';
import '../services/biometric_service.dart';

/// Provider for [AuthController].
final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final sessionService = ref.watch(sessionServiceProvider);
  final rememberMeService = ref.watch(rememberMeServiceProvider);
  final biometricService = ref.watch(biometricServiceProvider);

  return AuthController(
    authRepository: authRepository,
    sessionService: sessionService,
    rememberMeService: rememberMeService,
    biometricService: biometricService,
  );
});
