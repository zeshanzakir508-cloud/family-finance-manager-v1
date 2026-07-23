import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/onboarding_constants.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import 'onboarding_service.dart';

/// Implementation of OnboardingService using SharedPreferences
class OnboardingStorageService implements OnboardingService {
  final SharedPreferences _preferences;

  OnboardingStorageService(this._preferences);

  /// Get the progress key with version
  String get _progressKey {
    return '${OnboardingConstants.keyOnboardingProgress}_${OnboardingConstants.onboardingVersion}';
  }

  @override
  Future<OnboardingStatus> getStatus() async {
    final progress = await getProgress();
    return progress.status;
  }

  @override
  Future<OnboardingProgressModel> getProgress() async {
    try {
      final jsonString = _preferences.getString(_progressKey);
      if (jsonString == null) {
        return OnboardingProgressModel.initial();
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return OnboardingProgressModel.fromJson(jsonMap);
    } catch (e) {
      // If there's an error, return initial progress
      return OnboardingProgressModel.initial();
    }
  }

  @override
  Future<void> saveProgress(OnboardingProgressModel progress) async {
    try {
      final jsonString = jsonEncode(progress.toJson());
      await _preferences.setString(_progressKey, jsonString);
      await _preferences.setString(
        OnboardingConstants.keyOnboardingVersion,
        OnboardingConstants.onboardingVersion,
      );
    } catch (e) {
      throw Exception('Failed to save onboarding progress: $e');
    }
  }

  @override
  Future<void> markCompleted() async {
    final progress = await getProgress();
    final updatedProgress = progress.markCompleted();
    await saveProgress(updatedProgress);
    await _preferences.setBool(OnboardingConstants.keyOnboardingCompleted, true);
  }

  @override
  Future<void> markSkipped() async {
    final progress = await getProgress();
    final updatedProgress = progress.markSkipped();
    await saveProgress(updatedProgress);
    await _preferences.setBool(OnboardingConstants.keyOnboardingSkipped, true);
  }

  @override
  Future<void> reset() async {
    await _preferences.remove(_progressKey);
    await _preferences.remove(OnboardingConstants.keyOnboardingCompleted);
    await _preferences.remove(OnboardingConstants.keyOnboardingSkipped);
    await _preferences.setBool(OnboardingConstants.keyFirstLaunch, true);
  }

  @override
  Future<bool> isCompleted() async {
    return _preferences.getBool(OnboardingConstants.keyOnboardingCompleted) ?? false;
  }

  @override
  Future<bool> isSkipped() async {
    return _preferences.getBool(OnboardingConstants.keyOnboardingSkipped) ?? false;
  }

  @override
  Future<bool> isInProgress() async {
    final status = await getStatus();
    return status == OnboardingStatus.inProgress;
  }

  @override
  Future<bool> isFirstLaunch() async {
    return _preferences.getBool(OnboardingConstants.keyFirstLaunch) ?? true;
  }

  @override
  Future<void> markFirstLaunchSeen() async {
    await _preferences.setBool(OnboardingConstants.keyFirstLaunch, false);
  }

  @override
  Future<OnboardingStep> getCurrentStep() async {
    final progress = await getProgress();
    return progress.currentStep;
  }

  @override
  Future<void> setCurrentStep(OnboardingStep step) async {
    final progress = await getProgress();
    final updatedProgress = progress.copyWith(currentStep: step);
    await saveProgress(updatedProgress);
  }

  @override
  Future<void> markStepCompleted(OnboardingStep step) async {
    final progress = await getProgress();
    final updatedProgress = progress.markStepCompleted(step);
    
    // If all required steps are completed, update status
    if (updatedProgress.areAllRequiredStepsCompleted &&
        updatedProgress.status != OnboardingStatus.completed) {
      final finalProgress = updatedProgress.copyWith(
        status: OnboardingStatus.inProgress,
      );
      await saveProgress(finalProgress);
    } else {
      await saveProgress(updatedProgress);
    }
  }

  @override
  Future<void> markStepIncomplete(OnboardingStep step) async {
    final progress = await getProgress();
    final updatedProgress = progress.markStepIncomplete(step);
    await saveProgress(updatedProgress);
  }

  @override
  Future<bool> isStepCompleted(OnboardingStep step) async {
    final progress = await getProgress();
    return progress.isStepCompleted(step);
  }

  @override
  Future<List<OnboardingStep>> getCompletedSteps() async {
    final progress = await getProgress();
    return progress.completedStepList;
  }

  @override
  Future<double> getProgressPercentage() async {
    final progress = await getProgress();
    return progress.progress;
  }

  @override
  Future<int> getCompletedStepsCount() async {
    final progress = await getProgress();
    return progress.completedCount;
  }

  @override
  Future<int> getTotalSteps() async {
    return OnboardingStep.values.length;
  }

  @override
  Future<List<OnboardingStep>> getRemainingSteps() async {
    final progress = await getProgress();
    return progress.incompleteStepList;
  }

  @override
  Future<bool> areAllRequiredStepsCompleted() async {
    final progress = await getProgress();
    return progress.areAllRequiredStepsCompleted;
  }

  @override
  Future<void> saveMetadata(Map<String, dynamic> metadata) async {
    final progress = await getProgress();
    final updatedMetadata = {
      ...?progress.metadata,
      ...metadata,
    };
    final updatedProgress = progress.copyWith(metadata: updatedMetadata);
    await saveProgress(updatedProgress);
  }

  @override
  Future<Map<String, dynamic>?> getMetadata() async {
    final progress = await getProgress();
    return progress.metadata;
  }

  @override
  Future<void> clearAllData() async {
    await _preferences.remove(_progressKey);
    await _preferences.remove(OnboardingConstants.keyOnboardingCompleted);
    await _preferences.remove(OnboardingConstants.keyOnboardingSkipped);
    await _preferences.remove(OnboardingConstants.keyFirstLaunch);
    await _preferences.remove(OnboardingConstants.keyOnboardingVersion);
  }

  @override
  Future<String> getVersion() async {
    return _preferences.getString(OnboardingConstants.keyOnboardingVersion) ??
        OnboardingConstants.defaultVersion;
  }

  @override
  Future<bool> needsMigration() async {
    final currentVersion = await getVersion();
    return currentVersion != OnboardingConstants.onboardingVersion;
  }

  @override
  Future<void> migrate() async {
    if (!await needsMigration()) return;

    final progress = await getProgress();
    // If progress exists, migrate it
    if (progress.status != OnboardingStatus.notStarted) {
      // Update version
      final migratedProgress = progress.copyWith(
        version: OnboardingConstants.onboardingVersion,
        lastUpdatedAt: DateTime.now(),
      );
      await saveProgress(migratedProgress);
    }

    // Update version key
    await _preferences.setString(
      OnboardingConstants.keyOnboardingVersion,
      OnboardingConstants.onboardingVersion,
    );
  }

  @override
  Future<Duration?> getTimeElapsed() async {
    final progress = await getProgress();
    return progress.timeElapsed;
  }

  @override
  Future<Duration?> getTimeSinceCompletion() async {
    final progress = await getProgress();
    return progress.timeSinceCompletion;
  }

  @override
  Future<bool> isStale() async {
    final progress = await getProgress();
    if (progress.status != OnboardingStatus.inProgress) return false;
    
    final elapsed = progress.timeElapsed;
    if (elapsed == null) return false;
    
    return elapsed > OnboardingConstants.maxOnboardingDuration;
  }

  @override
  Future<void> resetStale() async {
    if (await isStale()) {
      // Reset to initial state but keep any completed steps
      final progress = await getProgress();
      final resetProgress = OnboardingProgressModel(
        status: OnboardingStatus.notStarted,
        currentStep: OnboardingStep.welcome,
        completedSteps: [],
        version: OnboardingConstants.onboardingVersion,
      );
      await saveProgress(resetProgress);
      await _preferences.remove(OnboardingConstants.keyOnboardingCompleted);
      await _preferences.remove(OnboardingConstants.keyOnboardingSkipped);
      await _preferences.setBool(OnboardingConstants.keyFirstLaunch, true);
    }
  }

  /// Helper method to get the progress key for a specific version
  String _getProgressKeyForVersion(String version) {
    return '${OnboardingConstants.keyOnboardingProgress}_$version';
  }

  /// Migrate from old version to new version
  Future<void> migrateFromOldVersion(String oldVersion) async {
    final oldKey = _getProgressKeyForVersion(oldVersion);
    final oldJsonString = _preferences.getString(oldKey);
    
    if (oldJsonString != null) {
      try {
        final oldJsonMap = jsonDecode(oldJsonString) as Map<String, dynamic>;
        final oldProgress = OnboardingProgressModel.fromJson(oldJsonMap);
        
        // Create new progress with updated version
        final newProgress = oldProgress.copyWith(
          version: OnboardingConstants.onboardingVersion,
          lastUpdatedAt: DateTime.now(),
        );
        
        await saveProgress(newProgress);
        await _preferences.remove(oldKey);
      } catch (e) {
        // If migration fails, start fresh
        await reset();
      }
    }
  }

  /// Check if onboarding data exists
  Future<bool> hasData() async {
    return _preferences.containsKey(_progressKey);
  }

  /// Get the number of times onboarding has been started
  Future<int> getStartCount() async {
    return _preferences.getInt('onboarding_start_count') ?? 0;
  }

  /// Increment the start count
  Future<void> incrementStartCount() async {
    final count = await getStartCount();
    await _preferences.setInt('onboarding_start_count', count + 1);
  }

  /// Get the last time onboarding was accessed
  Future<DateTime?> getLastAccessTime() async {
    final timestamp = _preferences.getString('onboarding_last_access');
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  /// Update the last access time
  Future<void> updateLastAccessTime() async {
    await _preferences.setString(
      'onboarding_last_access',
      DateTime.now().toIso8601String(),
    );
  }

  /// Check if the user is close to completing onboarding
  Future<bool> isNearCompletion() async {
    final progress = await getProgress();
    final remaining = progress.remainingRequiredSteps.length;
    return remaining <= 2 && progress.status == OnboardingStatus.inProgress;
  }

  /// Get the completion rate (ratio of completed to total steps)
  Future<double> getCompletionRate() async {
    final progress = await getProgress();
    if (progress.totalSteps == 0) return 0.0;
    return progress.completedCount / progress.totalSteps;
  }

  /// Get a summary of onboarding progress
  Future<Map<String, dynamic>> getProgressSummary() async {
    final progress = await getProgress();
    return {
      'status': progress.status.name,
      'currentStep': progress.currentStep.name,
      'completedSteps': progress.completedCount,
      'totalSteps': progress.totalSteps,
      'progressPercentage': progress.progressPercentageValue,
      'requiredStepsCompleted': progress.hasCompletedAllRequiredSteps,
      'isComplete': progress.isComplete,
      'isInProgress': progress.isInProgress,
      'startedAt': progress.startedAt?.toIso8601String(),
      'completedAt': progress.completedAt?.toIso8601String(),
      'version': progress.version,
      'timeElapsed': progress.formattedTimeElapsed,
    };
  }
}
