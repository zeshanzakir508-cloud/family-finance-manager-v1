import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../repositories/onboarding_repository.dart';
import '../validators/onboarding_validator.dart';
import 'onboarding_state.dart';

/// Notifier for onboarding state management
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository) : super(OnboardingState.initial()) {
    // Initialize on creation
    initialize();
  }

  /// Initialize the onboarding state
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
      
      // Check if first launch
      final isFirstLaunch = await _repository.isFirstLaunch();
      
      if (!isFirstLaunch) {
        // Not first launch, check if onboarding is complete
        final isCompleted = await _repository.isCompleted();
        final isSkipped = await _repository.isSkipped();
        
        if (isCompleted || isSkipped) {
          // Onboarding is done, no need to show
          state = OnboardingState(
            isCompleted: isCompleted,
            isSkipped: isSkipped,
            status: isCompleted 
                ? OnboardingStatus.completed 
                : OnboardingStatus.skipped,
            isLoading: false,
          );
          return;
        }
      }
      
      // Load progress
      await loadProgress();
      
      // If not started, mark as in progress
      if (state.status == OnboardingStatus.notStarted) {
        await startOnboarding();
      }
      
      // Check for stale onboarding
      final isStale = await _repository.isStale();
      if (isStale) {
        await resetStale();
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to initialize onboarding: $e');
    }
  }

  /// Load progress from repository
  Future<void> loadProgress() async {
    try {
      final progress = await _repository.getProgress();
      final errors = await _repository.getCurrentStepErrors();
      final warnings = _getWarnings(progress);
      
      state = OnboardingState.fromProgress(
        progress,
        errors: errors,
        warnings: warnings,
      );
    } catch (e) {
      state = OnboardingState.error('Failed to load progress: $e');
    }
  }

  /// Start onboarding
  Future<void> startOnboarding() async {
    try {
      final progress = await _repository.getProgress();
      final startedProgress = progress.markStarted();
      await _repository.saveProgress(startedProgress);
      
      state = OnboardingState.fromProgress(startedProgress);
    } catch (e) {
      state = OnboardingState.error('Failed to start onboarding: $e');
    }
  }

  /// Go to the next step
  Future<void> next() async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      // Check if can advance
      if (!state.canAdvance) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Cannot advance to next step',
        );
        return;
      }
      
      // If on finish step, complete onboarding
      if (state.currentStep == OnboardingStep.finish) {
        await complete();
        return;
      }
      
      // Go to next step
      final nextStep = await _repository.goToNextStep();
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to go to next step: $e');
    }
  }

  /// Go to the previous step
  Future<void> back() async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      if (!state.canGoBack) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Cannot go back from this step',
        );
        return;
      }
      
      await _repository.goToPreviousStep();
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to go back: $e');
    }
  }

  /// Go to a specific step
  Future<void> goToStep(OnboardingStep step) async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      await _repository.goToStep(step);
      await loadProgress();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to go to step: $e');
    }
  }

  /// Complete the current step
  Future<void> completeStep(OnboardingStep step) async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      // Validate step
      final progress = await _repository.getProgress();
      if (!OnboardingValidator.isValidStep(step, progress)) {
        state = OnboardingState.error('Step is not valid: ${step.displayName}');
        return;
      }
      
      await _repository.completeStep(step);
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to complete step: $e');
    }
  }

  /// Skip the current step
  Future<void> skipStep(OnboardingStep step) async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      // Check if step can be skipped
      final progress = await _repository.getProgress();
      if (!OnboardingValidator.canSkipStep(step, progress)) {
        state = OnboardingState.error('Cannot skip this step');
        return;
      }
      
      await _repository.skipStep(step);
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to skip step: $e');
    }
  }

  /// Complete onboarding
  Future<void> complete() async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      // Check if can finish
      if (!state.canFinish) {
        state = OnboardingState.error('Cannot finish onboarding');
        return;
      }
      
      await _repository.markCompleted();
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to complete onboarding: $e');
    }
  }

  /// Skip onboarding
  Future<void> skip() async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      
      // Check if can skip
      if (!state.canSkipOnboarding) {
        state = OnboardingState.error('Cannot skip onboarding');
        return;
      }
      
      await _repository.markSkipped();
      await loadProgress();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to skip onboarding: $e');
    }
  }

  /// Reset onboarding
  Future<void> reset() async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      await _repository.reset();
      await loadProgress();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to reset onboarding: $e');
    }
  }

  /// Reset stale onboarding
  Future<void> resetStale() async {
    try {
      await _repository.resetStale();
      await loadProgress();
    } catch (e) {
      // Ignore error and continue
    }
  }

  /// Save metadata
  Future<void> saveMetadata(Map<String, dynamic> metadata) async {
    if (state.isLoading) return;
    
    try {
      state = state.copyWith(isLoading: true, hasError: false);
      await _repository.saveMetadata(metadata);
      await loadProgress();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = OnboardingState.error('Failed to save metadata: $e');
    }
  }

  /// Save family name
  Future<void> saveFamilyName(String familyName) async {
    await saveMetadata({'familyName': familyName});
  }

  /// Save account name
  Future<void> saveAccountName(String accountName) async {
    await saveMetadata({'accountName': accountName});
  }

  /// Save selected categories
  Future<void> saveSelectedCategories(List<String> categories) async {
    await saveMetadata({'selectedCategories': categories});
  }

  /// Save account balance
  Future<void> saveAccountBalance(double balance) async {
    await saveMetadata({'accountBalance': balance});
  }

  /// Refresh the current state
  Future<void> refresh() async {
    await loadProgress();
  }

  /// Get warnings for the current progress
  List<String> _getWarnings(OnboardingProgressModel progress) {
    final warnings = <String>[];
    
    // Check if onboarding is taking too long
    if (progress.isTakingTooLong) {
      warnings.add('Onboarding is taking longer than expected.');
    }
    
    // Check if user is near completion
    if (progress.remainingRequiredSteps.length <= 2 && 
        progress.status == OnboardingStatus.inProgress) {
      warnings.add('You\'re almost done! Just a few more steps.');
    }
    
    return warnings;
  }

  /// Dispose method
  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
