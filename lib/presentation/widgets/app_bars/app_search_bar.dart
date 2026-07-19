import 'package:flutter/material.dart';

/// A reusable Material 3 search bar.
///
/// Wraps Flutter's [SearchBar] while providing a consistent API
/// for search experiences across the application.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Search',
    this.leading,
    this.trailing,
    this.enabled = true,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String hintText;

  final Widget? leading;

  final List<Widget>? trailing;

  final bool enabled;
  final bool autoFocus;
  final bool readOnly;

  final VoidCallback? onTap;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      enabled: enabled,
      autoFocus: autoFocus,
      readOnly: readOnly,
      leading: leading ?? const Icon(Icons.search),
      trailing: [
        if (trailing != null) ...trailing!,
        if (controller != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller!.clear();
              onClear?.call();
              onChanged?.call('');
            },
          ),
      ],
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(
        theme.colorScheme.surfaceContainerHighest,
      ),
      side: WidgetStateProperty.all(
        BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
