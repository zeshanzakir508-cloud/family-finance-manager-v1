// lib/presentation/widgets/input_fields/app_search_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_text_field.dart';
import 'enums/text_field_variant.dart';
import 'enums/text_field_size.dart';
import 'enums/text_field_state.dart';

/// A search field with built-in search and clear functionality.
///
/// This widget provides a standardized search input field with a search icon,
/// clear button (when text is present), and search-specific keyboard actions.
///
/// Example:
/// ```dart
/// AppSearchField(
///   controller: _searchController,
///   hintText: 'Search products...',
///   onChanged: (value) => filterResults(value),
///   onClear: () => clearFilters(),
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// Controller for the search field.
  final TextEditingController? controller;

  /// Focus node for the search field.
  final FocusNode? focusNode;

  /// The hint text displayed inside the search field.
  final String? hintText;

  /// The label text displayed above the search field.
  final String? labelText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits the search.
  final ValueChanged<String>? onSubmitted;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// Callback when the clear button is pressed.
  final VoidCallback? onClear;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// The visual variant of the search field.
  final TextFieldVariant variant;

  /// The size of the search field.
  final TextFieldSize size;

  /// The current state of the search field.
  final TextFieldState state;

  /// Custom validator function.
  final String? Function(String?)? validator;

  /// Custom input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Creates a new [AppSearchField].
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.labelText,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.textInputAction = TextInputAction.search,
    this.variant = TextFieldVariant.outlined,
    this.size = TextFieldSize.medium,
    this.state = TextFieldState.normal,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      _controller = widget.controller ?? TextEditingController();
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    setState(() {
      _hasText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppTextField(
      controller: _controller,
      focusNode: widget.focusNode,
      labelText: widget.labelText,
      hintText: widget.hintText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      maxLines: 1,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      variant: widget.variant,
      size: widget.size,
      state: widget.state,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _hasText
          ? IconButton(
              icon: Icon(
                Icons.close,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              onPressed: _clearSearch,
              tooltip: 'Clear search',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              splashRadius: 16,
            )
          : null,
    );
  }
}
