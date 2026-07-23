import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../models/onboarding_page_model.dart';
import '../repositories/onboarding_repository.dart';
import '../validators/onboarding_validator.dart';

/// Business logic controller for onboarding flow
class OnboardingController extends ChangeNotifier {
  final OnboardingRepository _repository;

  /// Current progress model
  OnboardingProgressModel? _progress;

  /// Whether the controller is loading
  bool _isLoading = false;

  /// Error message if any
  String? _errorMessage;

  /// Constructor
  OnboardingController(this._repository) {
    initialize();
  }

  /// Get the current progress
  OnboardingProgressModel? get progress => _progress;

  /// Get the current status
  OnboardingStatus get status => _progress?.status ?? OnboardingStatus.notStarted;

  /// Get the current step
  OnboardingStep get currentStep => _progress?.currentStep ?? OnboardingStep.welcome;

  /// Get the current page model
  OnboardingPageModel get currentPage => OnboardingPageModel.fromStep(currentStep);

  /// Check if onboarding is completed
  bool get isCompleted => _progress?.isComplete ?? false;

  /// Check if onboarding is in progress
  bool get isInProgress => _progress?.isInProgress ?? false;

  /// Check if onboarding is not started
  bool get isNotStarted => _progress?.isNotStarted ?? true;

  /// Check if onboarding is skipped
  bool get isSkipped => _progress?.isSkipped ?? false;

  /// Get the total number of steps
  int get totalSteps => OnboardingStep.values.length;

  /// Get the number of completed steps
  int get completedSteps => _progress?.completedCount ?? 0;

  /// Get the number of remaining steps
  int get remainingSteps => _progress?.remainingSteps ?? totalSteps;

  /// Get the progress percentage (0.0 - 1.0)
  double get progressValue => _progress?.progress ?? 0.0;

  /// Get the progress percentage string
  String get progressPercentage => _progress?.progressPercentage ?? '0%';

  /// Get the current step index
  int get currentStepIndex => currentStep.index;

  /// Get the next step
  OnboardingStep? get nextStep => currentStep.next;

  /// Get the previous step
  OnboardingStep? get previousStep => currentStep.previous;

  /// Check if the current step is the first step
  bool get isFirstStep => currentStep == OnboardingStep.welcome;

  /// Check if the current step is the last step
  bool get isLastStep => currentStep == OnboardingStep.finish;

  /// Check if the user can advance
  bool get canAdvance {
    if (_progress == null) return false;
    return OnboardingValidator.canAdvanceToNextStep(_progress!, currentStep);
  }

  /// Check if the user can go back
  bool get canGoBack {
    return OnboardingValidator.canGoBack(currentStep);
  }

  /// Check if the user can skip onboarding
  bool get canSkipOnboarding {
    if (_progress == null) return false;
    return OnboardingValidator.canSkipOnboarding(_progress!);
  }

  /// Check if the user can finish onboarding
  bool get canFinish {
    if (_progress == null) return false;
    return OnboardingValidator.validateFinish(_progress!);
  }

  /// Check if all required steps are completed
  bool get allRequiredStepsCompleted {
    return _progress?.areAllRequiredStepsCompleted ?? false;
  }

  /// Get the list of completed steps
  List<OnboardingStep> get completedStepList {
    return _progress?.completedStepList ?? [];
  }

  /// Get the list of remaining steps
  List<OnboardingStep> get remainingStepList {
    return _progress?.incompleteStepList ?? [];
  }

  /// Check if the controller is loading
  bool get isLoading => _isLoading;

  /// Get the error message
  String? get errorMessage => _errorMessage;

  /// Get the onboarding metadata
  Map<String, dynamic>? get metadata => _progress?.metadata;

  /// Get the family name
  String? get familyName => metadata?['familyName'] as String?;

  /// Get the account name
  String? get accountName => metadata?['accountName'] as String?;

  /// Get the selected categories
  List<String> get selectedCategories {
    final categories = metadata?['selectedCategories'] as List?;
    if (categories == null) return [];
    return categories.cast<String>();
  }

  /// Get the account balance
  double? get accountBalance => metadata?['accountBalance'] as double?;

  /// Get the time elapsed
  Duration? get timeElapsed => _progress?.timeElapsed;

  /// Get the time since completion
  Duration? get timeSinceCompletion => _progress?.timeSinceCompletion;

  /// Initialize the controller
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if first launch
      final isFirstLaunch = await _repository.isFirstLaunch();

      if (!isFirstLaunch) {
        final isCompleted = await _repository.isCompleted();
        final isSkipped = await _repository.isSkipped();

        if (isCompleted || isSkipped) {
          _progress = OnboardingProgressModel(
            status: isCompleted ? OnboardingStatus.completed : OnboardingStatus.skipped,
            currentStep: OnboardingStep.finish,
            completedSteps: List.generate(OnboardingStep.values.length, (i) => i),
            completedAt: DateTime.now(),
            version: await _repository.getVersion(),
          );
          _setLoading(false);
          notifyListeners();
          return;
        }
      }

      // Load progress
      await loadProgress();

      // If not started, mark as started
      if (status == OnboardingStatus.notStarted) {
        await startOnboarding();
      }

      // Check for stale onboarding
      if (await _repository.isStale()) {
        await _repository.resetStale();
        await loadProgress();
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize onboarding: $e');
      _setLoading(false);
    }
  }

  /// Load progress from repository
  Future<void> loadProgress() async {
    try {
      _clearError();
      _progress = await _repository.getProgress();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load progress: $e');
      rethrow;
    }
  }

  /// Start onboarding
  Future<void> startOnboarding() async {
    try {
      _clearError();
      final progress = await _repository.getProgress();
      final startedProgress = progress.markStarted();
      await _repository.saveProgress(startedProgress);
      _progress = startedProgress;
      notifyListeners();
    } catch (e) {
      _setError('Failed to start onboarding: $e');
      rethrow;
    }
  }

  /// Go to the next step
  Future<void> next() async {
    if (_isLoading) return;
    if (!canAdvance) {
      _setError('Cannot advance to next step');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // If on finish step, complete onboarding
      if (currentStep == OnboardingStep.finish) {
        await complete();
        _setLoading(false);
        return;
      }

      // Mark current step as completed
      await _repository.completeStep(currentStep);

      // Go to next step
      final nextStep = await _repository.goToNextStep();
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to go to next step: $e');
      _setLoading(false);
    }
  }

  /// Go to the previous step
  Future<void> back() async {
    if (_isLoading) return;
    if (!canGoBack) {
      _setError('Cannot go back from this step');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      await _repository.goToPreviousStep();
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to go back: $e');
      _setLoading(false);
    }
  }

  /// Go to a specific step
  Future<void> goToStep(OnboardingStep step) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.goToStep(step);
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to go to step: $e');
      _setLoading(false);
    }
  }

  /// Complete the current step
  Future<void> completeCurrentStep() async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.completeStep(currentStep);
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to complete step: $e');
      _setLoading(false);
    }
  }

  /// Complete a specific step
  Future<void> completeStep(OnboardingStep step) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      // Validate the step
      final progress = await _repository.getProgress();
      if (!OnboardingValidator.isValidStep(step, progress)) {
        _setError('Step is not valid: ${step.displayName}');
        _setLoading(false);
        return;
      }

      await _repository.completeStep(step);
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to complete step: $e');
      _setLoading(false);
    }
  }

  /// Skip a specific step
  Future<void> skipStep(OnboardingStep step) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      // Check if step can be skipped
      final progress = await _repository.getProgress();
      if (!OnboardingValidator.canSkipStep(step, progress)) {
        _setError('Cannot skip this step');
        _setLoading(false);
        return;
      }

      await _repository.skipStep(step);
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to skip step: $e');
      _setLoading(false);
    }
  }

  /// Complete onboarding
  Future<void> complete() async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      // Check if can finish
      if (!canFinish) {
        _setError('Cannot finish onboarding. Please complete all required steps.');
        _setLoading(false);
        return;
      }

      await _repository.markCompleted();
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to complete onboarding: $e');
      _setLoading(false);
    }
  }

  /// Skip onboarding
  Future<void> skip() async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      // Check if can skip
      if (!canSkipOnboarding) {
        _setError('Cannot skip onboarding');
        _setLoading(false);
        return;
      }

      await _repository.markSkipped();
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to skip onboarding: $e');
      _setLoading(false);
    }
  }

  /// Reset onboarding
  Future<void> reset() async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.reset();
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to reset onboarding: $e');
      _setLoading(false);
    }
  }

  /// Save metadata
  Future<void> saveMetadata(Map<String, dynamic> metadata) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.saveMetadata(metadata);
      _progress = await _repository.getProgress();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save metadata: $e');
      _setLoading(false);
    }
  }

  /// Save family name
  Future<void> saveFamilyName(String name) async {
    await saveMetadata({'familyName': name});
  }

  /// Save account name
  Future<void> saveAccountName(String name) async {
    await saveMetadata({'accountName': name});
  }

  /// Save selected categories
  Future<void> saveSelectedCategories(List<String> categories) async {
    await saveMetadata({'selectedCategories': categories});
  }

  /// Save account balance
  Future<void> saveAccountBalance(double balance) async {
    await saveMetadata({'accountBalance': balance});
  }

  /// Check if a step is completed
  bool isStepCompleted(OnboardingStep step) {
    return _progress?.isStepCompleted(step) ?? false;
  }

  /// Get validation errors for the current step
  List<String> getCurrentStepErrors() {
    if (_progress == null) return [];
    final error = OnboardingValidator.getValidationError(currentStep, _progress!);
    return error != null ? [error] : [];
  }

  /// Get the completion message
  String getCompletionMessage() {
    if (_progress == null) return 'Ready to start onboarding';
    return OnboardingValidator.getCompletionMessage(_progress!);
  }

  /// Get the onboarding summary
  Future<Map<String, dynamic>> getSummary() async {
    return await _repository.getOnboardingSummary();
  }

  /// Check if onboarding is near completion
  Future<bool> isNearCompletion() async {
    return await _repository.isNearCompletion();
  }

  /// Get the recommended next step
  Future<OnboardingStep> getRecommendedNextStep() async {
    return await _repository.getRecommendedNextStep();
  }

  /// Get the next incomplete required step
  Future<OnboardingStep?> getNextIncompleteRequiredStep() async {
    return await _repository.getNextIncompleteRequiredStep();
  }

  /// Validate the entire flow
  OnboardingValidationResult validateFlow() {
    if (_progress == null) {
      return OnboardingValidationResult.failure(
        OnboardingProgressModel.initial(),
        ['No progress data available'],
      );
    }
    return OnboardingValidator.validateFlow(_progress!);
  }

  /// Check if the current step is valid
  bool get isCurrentStepValid {
    if (_progress == null) return false;
    return OnboardingValidator.isValidStep(currentStep, _progress!);
  }

  /// Get the step display name
  String getStepDisplayName(OnboardingStep step) {
    return step.displayName;
  }

  /// Get the step icon
  IconData getStepIcon(OnboardingStep step) {
    return step.icon;
  }

  /// Get the step color
  Color getStepColor(OnboardingStep step) {
    return step.color;
  }

  /// Get all pages
  List<OnboardingPageModel> getAllPages() {
    return OnboardingPageModel.getAllPages();
  }

  /// Get page for a specific step
  OnboardingPageModel getPageForStep(OnboardingStep step) {
    return OnboardingPageModel.fromStep(step);
  }

  /// Check if the controller has data
  bool get hasData => _progress != null && _progress!.status != OnboardingStatus.notStarted;

  /// Clear any error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh the controller state
  Future<void> refresh() async {
    await loadProgress();
  }

  /// Dispose the controller
  @override
  void dispose() {
    super.dispose();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
