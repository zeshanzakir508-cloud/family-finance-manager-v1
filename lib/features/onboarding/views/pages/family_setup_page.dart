import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/onboarding_provider.dart';
import '../sections/family_options_section.dart';
import '../widgets/onboarding_text_field.dart';

/// Family Setup page
class FamilySetupPage extends ConsumerStatefulWidget {
  const FamilySetupPage({super.key});

  @override
  ConsumerState<FamilySetupPage> createState() => _FamilySetupPageState();
}

class _FamilySetupPageState extends ConsumerState<FamilySetupPage> {
  final TextEditingController _familyNameController = TextEditingController();
  String _selectedOption = 'create'; // 'create' or 'join'
  bool _isFamilySetUp = false;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  void _loadFamilyData() {
    final metadata = ref.read(onboardingMetadataProvider);
    final familyName = metadata?['familyName'] as String?;
    if (familyName != null && familyName.isNotEmpty) {
      _familyNameController.text = familyName;
      _isFamilySetUp = true;
    }
  }

  void _saveFamilyData() {
    final name = _familyNameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(onboardingNotifierProvider.notifier).saveMetadata({
        'familyName': name,
        'familySetup': true,
      });
      
      // Mark step as complete
      ref.read(onboardingNotifierProvider.notifier).completeStep(OnboardingStep.family);
      
      setState(() {
        _isFamilySetUp = true;
      });
    }
  }

  void _skipFamilySetup() {
    ref.read(onboardingNotifierProvider.notifier).skipStep(OnboardingStep.family);
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
            'Family Setup',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create or join a family to manage finances together.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Family options
          FamilyOptionsSection(
            selectedOption: _selectedOption,
            onOptionChanged: (option) {
              setState(() {
                _selectedOption = option;
              });
            },
          ),
          const SizedBox(height: 24),
          // Family name input
          TextField(
            controller: _familyNameController,
            decoration: InputDecoration(
              labelText: 'Family Name',
              hintText: 'Enter your family name',
              prefixIcon: const Icon(Icons.family_restroom),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabled: !_isFamilySetUp,
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          if (!_isFamilySetUp) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _familyNameController.text.trim().isNotEmpty
                        ? _saveFamilyData
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedOption == 'create' ? 'Create Family' : 'Join Family',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _skipFamilySetup,
              child: const Text('Skip this step'),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Family "${_familyNameController.text}" is set up!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
