// lib/presentation/widgets/domain/reports/report_filter.dart

import 'package:flutter/material.dart';

import '../../buttons/app_button.dart';
import '../../buttons/enums/app_button_variant.dart';
import '../../buttons/enums/app_button_size.dart';
import '../../layout/app_section.dart';
import '../../layout/enums/section_variant.dart';

/// A report filter widget.
///
/// This widget provides a standardized report filter for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// ReportFilter(
///   dateRangeLabel: 'Last 30 days',
///   onDateRangeTap: () => showDatePicker(),
///   categoryLabel: 'All Categories',
///   onCategoryTap: () => showCategoryPicker(),
///   onApply: () => generateReport(),
/// )
/// ```
class ReportFilter extends StatelessWidget {
  /// The date range label.
  final String? dateRangeLabel;

  /// Callback when date range is tapped.
  final VoidCallback? onDateRangeTap;

  /// The category label.
  final String? categoryLabel;

  /// Callback when category is tapped.
  final VoidCallback? onCategoryTap;

  /// Callback when apply is pressed.
  final VoidCallback? onApply;

  /// Whether the filter is loading.
  final bool isLoading;

  /// Creates a new [ReportFilter].
  const ReportFilter({
    super.key,
    this.dateRangeLabel,
    this.onDateRangeTap,
    this.categoryLabel,
    this.onCategoryTap,
    this.onApply,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: 'Filters',
      variant: SectionVariant.filled,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: dateRangeLabel ?? 'Select Date',
                  onPressed: onDateRangeTap,
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: categoryLabel ?? 'All Categories',
                  onPressed: onCategoryTap,
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Apply Filters',
            onPressed: onApply,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.medium,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
