import 'package:flutter/material.dart';
import '../../enums/onboarding_step.dart';

/// Progress indicator section showing step progress
class ProgressIndicatorSection extends StatelessWidget {
  final double progress;
  final OnboardingStep currentStep;
  final int totalSteps;

  const ProgressIndicatorSection({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep.index + 1} of $totalSteps',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getProgressColor(progress),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.25) return Colors.blue;
    if (progress < 0.50) return Colors.orange;
    if (progress < 0.75) return Colors.purple;
    if (progress < 1.0) return Colors.green;
    return Colors.green;
  }
}
