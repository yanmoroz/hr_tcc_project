import 'package:flutter/material.dart';

/// A platform-adaptive refresh indicator widget.
///
/// Uses [RefreshIndicator.adaptive] which automatically displays
/// the appropriate style for the current platform:
/// - iOS/macOS: Cupertino style
/// - Android/other: Material style
///
/// The child must be a scrollable widget (ListView, CustomScrollView, etc.)
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    super.key,
  });

  /// Called when the user pulls down to refresh.
  final Future<void> Function() onRefresh;

  /// The scrollable child widget.
  final Widget child;

  /// The color of the refresh indicator (Android only).
  final Color? color;

  /// The background color of the refresh indicator (Android only).
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      color: color,
      backgroundColor: backgroundColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: child,
      ),
    );
  }
}
