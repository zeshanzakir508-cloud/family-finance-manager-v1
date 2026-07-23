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
  Widget build(BuildContext context, WidgetRef ref)
