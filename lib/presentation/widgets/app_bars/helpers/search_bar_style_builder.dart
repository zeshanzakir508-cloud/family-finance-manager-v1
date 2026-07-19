abstract final class SearchBarStyleBuilder {
  static SearchBarStyle build({
    required BuildContext context,
    required bool enabled,
  });
}
@immutable
class SearchBarStyle {
  const SearchBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.borderColor,
    required this.disabledBorderColor,
    required this.borderRadius,
    required this.elevation,
    required this.iconSize,
    required this.textStyle,
    required this.hintStyle,
    required this.contentPadding,
  });

  final Color backgroundColor;
  final Color foregroundColor;

  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;

  final Color borderColor;
  final Color disabledBorderColor;

  final BorderRadius borderRadius;

  final double elevation;
  final double iconSize;

  final TextStyle textStyle;
  final TextStyle hintStyle;

  final EdgeInsets contentPadding;

  SearchBarColors resolve({
    required bool enabled,
  });
}
@immutable
class SearchBarColors {
  const SearchBarColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
final style = SearchBarStyleBuilder.build(
  context: context,
  enabled: enabled,
);

final colors = style.resolve(
  enabled: enabled,
);
backgroundColor: WidgetStatePropertyAll(colors.background),

side: WidgetStatePropertyAll(
  BorderSide(color: colors.border),
),

textStyle: WidgetStatePropertyAll(style.textStyle),

hintStyle: WidgetStatePropertyAll(style.hintStyle),

elevation: WidgetStatePropertyAll(style.elevation),

shape: WidgetStatePropertyAll(
  RoundedRectangleBorder(
    borderRadius: style.borderRadius,
  ),
),
