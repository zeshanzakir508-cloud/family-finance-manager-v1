import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_card.dart';

/// Terms and Privacy page
class TermsPrivacyPage extends ConsumerStatefulWidget {
  const TermsPrivacyPage({super.key});

  @override
  ConsumerState<TermsPrivacyPage> createState() => _TermsPrivacyPageState();
}

class _TermsPrivacyPageState extends ConsumerState<TermsPrivacyPage> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  @override
  void initState() {
    super.initState();
    _loadAcceptanceStatus();
  }

  void _loadAcceptanceStatus() {
    final metadata = ref.read(onboardingMetadataProvider);
    _termsAccepted = metadata?['termsAccepted'] as bool? ?? false;
    _privacyAccepted = metadata?['privacyAccepted'] as bool? ?? false;
  }

  void _saveAcceptanceStatus() {
    ref.read(onboardingNotifierProvider.notifier).saveMetadata({
      'termsAccepted': _termsAccepted,
      'privacyAccepted': _privacyAccepted,
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Terms & Privacy',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please review and accept our terms of service.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Terms Card
          OnboardingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.description, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    const Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                        _saveAcceptanceStatus();
                        // Mark step as complete if both accepted
                        if (_termsAccepted && _privacyAccepted) {
                          ref
                              .read(onboardingNotifierProvider.notifier)
                              .completeStep(OnboardingStep.terms);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'By accepting, you agree to our terms of service. '
                  'This includes our user agreement, data processing, '
                  'and service conditions.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Navigate to full terms
                  },
                  child: const Text('Read Full Terms'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Privacy Card
          OnboardingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.privacy_tip, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: _privacyAccepted,
                      onChanged: (value) {
                        setState(() {
                          _privacyAccepted = value ?? false;
                        });
                        _saveAcceptanceStatus();
                        // Mark step as complete if both accepted
                        if (_termsAccepted && _privacyAccepted) {
                          ref
                              .read(onboardingNotifierProvider.notifier)
                              .completeStep(OnboardingStep.terms);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'We value your privacy. Our privacy policy explains how '
                  'we collect, use, and protect your personal data.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Navigate to full privacy policy
                  },
                  child: const Text('Read Privacy Policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_termsAccepted && _privacyAccepted)
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  (_termsAccepted && _privacyAccepted)
                      ? Icons.check_circle
                      : Icons.warning,
                  color: (_termsAccepted && _privacyAccepted)
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    (_termsAccepted && _privacyAccepted)
                        ? 'You have accepted all terms and conditions.'
                        : 'Please accept both terms and privacy policy to continue.',
                    style: TextStyle(
                      fontSize: 14,
                      color: (_termsAccepted && _privacyAccepted)
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
