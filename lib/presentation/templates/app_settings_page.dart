// lib/presentation/templates/app_settings_page.dart

import 'package:flutter/material.dart';

import 'app_page.dart';
import 'enums/page_density.dart';
import 'enums/page_scroll_behavior.dart';
import 'enums/page_variant.dart';

/// A settings page template with consistent styling.
///
/// This widget provides a standardized settings page template that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSettingsPage(
///   title: 'Settings',
///   sections: [
///     SettingsSection(
///       title: 'General',
///       items: [
///         SettingsItem(label: 'Dark Mode', trailing: Switch(...)),
///         SettingsItem(label: 'Language', trailing: Text('English')),
///       ],
///     ),
///   ],
/// )
/// ```
class AppSettingsPage extends StatelessWidget {
  /// The title of the page.
  final String? title;

  /// The subtitle of the page.
  final String? subtitle;

  /// The settings sections.
  final List<SettingsSection> sections;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// The visual variant of the page.
  final PageVariant variant;

  /// The density of the page.
  final PageDensity density;

  /// The app bar widget (optional).
  final PreferredSizeWidget? appBar;

  /// Creates a new [AppSettingsPage].
  const AppSettingsPage({
    super.key,
    this.title,
    this.subtitle,
    required this.sections,
    this.leading,
    this.trailing,
    this.variant = PageVariant.standard,
    this.density = PageDensity.comfortable,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        final items = <Widget>[];

        if (section.title != null) {
          items.add(
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                section.title!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          );
        }

        items.addAll(
          section.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == section.items.length - 1;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: isLast
                    ? BorderRadius.vertical(bottom: Radius.circular(8))
                    : null,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: ListTile(
                leading: item.icon != null
                    ? Icon(item.icon, color: colorScheme.onSurfaceVariant)
                    : null,
                title: Text(item.label),
                subtitle: item.subtitle != null
                    ? Text(item.subtitle!)
                    : null,
                trailing: item.trailing,
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                minTileHeight: 56,
              ),
            );
          }).toList(),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );
      }).toList(),
    );

    return AppPage(
      child: body,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      variant: variant,
      density: density,
      scrollBehavior: PageScrollBehavior.normal,
      appBar: appBar,
    );
  }
}

/// A settings section.
class SettingsSection {
  /// The section title.
  final String? title;

  /// The section items.
  final List<SettingsItem> items;

  /// Creates a new [SettingsSection].
  const SettingsSection({
    this.title,
    required this.items,
  });
}

/// A settings item.
class SettingsItem {
  /// The item label.
  final String label;

  /// The item subtitle.
  final String? subtitle;

  /// The item icon.
  final IconData? icon;

  /// The trailing widget.
  final Widget? trailing;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Creates a new [SettingsItem].
  const SettingsItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });
}
