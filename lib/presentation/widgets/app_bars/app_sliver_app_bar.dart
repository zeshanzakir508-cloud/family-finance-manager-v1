class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({
    super.key,

    required this.title,

    this.subtitle,

    this.leading,

    this.actions,

    this.bottom,

    this.flexibleSpace,

    this.expandedHeight,

    this.collapsedHeight,

    this.floating = false,

    this.pinned = true,

    this.snap = false,

    this.stretch = false,

    this.centerTitle,

    this.automaticallyImplyLeading = true,

    this.variant = AppBarVariant.primary,

    this.size = AppBarSize.large,

    this.selected = false,

    this.disabled = false,

    this.backgroundColor,

    this.foregroundColor,

    this.elevation,

    this.shape,
  });
  final String title;
final String? subtitle;

final Widget? leading;
final List<Widget>? actions;

final PreferredSizeWidget? bottom;

final Widget? flexibleSpace;

final double? expandedHeight;
final double? collapsedHeight;

final bool floating;
final bool pinned;
final bool snap;
final bool stretch;

final bool? centerTitle;
final bool automaticallyImplyLeading;

final AppBarVariant variant;
final AppBarSize size;

final bool selected;
final bool disabled;

final Color? backgroundColor;
final Color? foregroundColor;

final double? elevation;
final ShapeBorder? shape;
