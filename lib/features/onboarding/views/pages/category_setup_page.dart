import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/onboarding_provider.dart';
import '../../models/onboarding_page_model.dart';
import '../sections/category_preview_section.dart';

/// Category Setup page
class CategorySetupPage extends ConsumerStatefulWidget {
  const CategorySetupPage({super.key});

  @override
  ConsumerState<CategorySetupPage> createState() => _CategorySetupPageState();
}

class _CategorySetupPageState extends ConsumerState<CategorySetupPage> {
  List<CategoryItem> _categories = [];
  bool _isCategorySetUp = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final metadata = ref.read(onboardingMetadataProvider);
    final selectedCategories = metadata?['selectedCategories'] as List?;
    
    // Get default categories
    final defaultCategories = OnboardingPageModel.categories().categories ?? [];
    
    if (selectedCategories != null) {
      _categories = defaultCategories.map((cat) {
        final isSelected = selectedCategories.contains(cat.id);
        return cat.copyWith(selected: isSelected);
      }).toList();
      _isCategorySetUp = selectedCategories.isNotEmpty;
    } else {
      _categories = defaultCategories;
    }
  }

  void _toggleCategory(String id) {
    setState(() {
      final index = _categories.indexWhere((cat) => cat.id == id);
      if (index != -1) {
        _categories[index] = _categories[index].copyWith(
          selected: !_categories[index].selected,
        );
      }
    });
  }

  void _saveCategories() {
    final selectedIds = _categories
        .where((cat) => cat.selected)
        .map((cat) => cat.id)
        .toList();
    
    if (selectedIds.isNotEmpty) {
      ref.read(onboardingNotifierProvider.notifier).saveMetadata({
        'selectedCategories': selectedIds,
        'categorySetup': true,
      });
      
      // Mark step as complete
      ref.read(onboardingNotifierProvider.notifier).completeStep(OnboardingStep.categories);
      
      setState(() {
        _isCategorySetUp = true;
      });
    }
  }

  void _skipCategories() {
    ref.read(onboardingNotifierProvider.notifier).skipStep(OnboardingStep.categories);
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
            'Choose Categories',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select categories that matter to your family.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Categories grid
          CategoryPreviewSection(
            categories: _categories,
            onCategoryTapped: _toggleCategory,
          ),
          const SizedBox(height: 16),
          // Info text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.pink.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select at least one category to continue.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.pink.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          if (!_isCategorySetUp) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _categories.any((cat) => cat.selected)
                        ? _saveCategories
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _skipCategories,
              child: const Text('Skip this step'),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.pink),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Selected ${_categories.where((cat) => cat.selected).length} categories!',
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
