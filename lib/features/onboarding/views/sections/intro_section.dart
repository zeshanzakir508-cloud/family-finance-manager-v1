import 'package:flutter/material.dart';
import '../widgets/onboarding_image.dart';

/// Welcome/Intro content section
class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image
        OnboardingImage(
          assetPath: 'assets/images/onboarding/welcome.png',
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        // Title
        const Text(
          'Welcome to Family Budget',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Subtitle
        const Text(
          'Manage your family finances together,\neasily and securely.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Features
        _FeatureItem(
          icon: Icons.security,
          title: 'Secure',
          description: 'Your data is encrypted and safe',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.people,
          title: 'Family Sharing',
          description: 'Share budgets with family members',
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.trending_up,
          title: 'Smart Insights',
          description: 'Get personalized financial insights',
          color: Colors.orange,
        ),
      ],
    );
  }
}

/// Feature item widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
