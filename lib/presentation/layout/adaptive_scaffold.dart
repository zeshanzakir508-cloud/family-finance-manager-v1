// lib/presentation/layout/adaptive_scaffold.dart

import 'package:flutter/material.dart';

import 'app_layout.dart';
import 'layout_helpers.dart';
import 'responsive_builder.dart';

/// A scaffold that adapts its layout based on screen size.
///
/// This widget provides a consistent scaffold structure that automatically
/// adjusts between mobile and desktop layouts.
///
/// Example:
/// ```dart
/// AdaptiveScaffold(
///   appBar: AppBar(title: Text('My App')),
///   body: MyContent(),
///   drawer: NavigationDrawer(),
///   navigationRail: NavigationRail(destinations: [...]),
/// )
/// ```
class AdaptiveScaffold extends StatelessWidget {
  /// The app bar to display on all screen sizes.
  final PreferredSizeWidget? appBar;

  /// The body content to display.
  final Widget body;

  /// The drawer to display on mobile devices.
  final Widget? drawer;

  /// The navigation rail to display on tablet and desktop.
  final Widget? navigationRail;

  /// The floating action button.
  final Widget? floatingActionButton;

  /// The floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The bottom navigation bar for mobile devices.
  final Widget? bottomNavigationBar;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Creates a new [AdaptiveScaffold].
  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.navigationRail,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => Scaffold(
        appBar: appBar,
        body: body,
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
      ),
      tablet: (context) => Scaffold(
        appBar: appBar,
        body: _buildTabletLayout(context),
        drawer: null, // Drawer not shown on tablet when using navigation rail
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
      ),
      desktop: (context) => Scaffold(
        appBar: appBar,
        body: _buildDesktopLayout(context),
        drawer: null,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    if (navigationRail != null) {
      return Row(
        children: [
          navigationRail!,
          Expanded(
            child: body,
          ),
        ],
      );
    }
    return body;
  }

  Widget _buildDesktopLayout(BuildContext context) {
    if (navigationRail != null) {
      return Row(
        children: [
          SizedBox(
            width: 72,
            child: navigationRail!,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.maxContentWidth,
                ),
                child: body,
              ),
            ),
          ),
        ],
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppLayout.maxContentWidth,
        ),
        child: body,
      ),
    );
  }
}
