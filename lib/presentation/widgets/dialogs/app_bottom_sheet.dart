import 'package:flutter/material.dart';

/// A reusable Material 3 bottom sheet.
///
/// This widget provides a consistent bottom sheet container that can be used
/// throughout the application. It contains no presentation logic other than
/// layout and styling.
///
/// Display it using:
///
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => AppBottomSheet(
///     title: 'Filters',
///     child: ...,
///   ),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  /// Optional title displayed at the top.
  final String? title;

  /// The primary content of the bottom sheet.
  final Widget child;

  /// Whether the sheet should respect the keyboard and use the available height.
  final bool isScrollControlled;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom padding for the content.
  final EdgeInsetsGeometry? padding;

  /// Custom sheet shape.
  final ShapeBorder? shape;

  /// Whether to display the drag handle.
  final bool showDragHandle;

  /// Creates a new [AppBottomSheet].
  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.isScrollControlled = false,
    this.backgroundColor,
    this.padding,
    this.shape,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Material(
        color: backgroundColor ?? colorScheme.surface,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: showDragHandle ? 12 : 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ).add(padding ?? EdgeInsets.zero),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              if (title != null) ...[
                Text(
                  title!,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
              Flexible(
                fit: FlexFit.loose,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
