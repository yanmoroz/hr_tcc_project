import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A platform-adaptive progress indicator widget.
///
/// Displays [CupertinoActivityIndicator] on iOS and
/// [CircularProgressIndicator] on Android/other platforms.
///
/// Supports both determinate and indeterminate modes:
/// - Indeterminate: Shows spinning animation (default)
/// - Determinate: Shows progress from 0.0 to 1.0 when [value] is provided
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    this.value,
    this.color,
    this.radius = 10.0,
    this.strokeWidth = 4.0,
    super.key,
  });

  /// The progress value (0.0 to 1.0) for determinate mode.
  /// If null, shows indeterminate animation.
  final double? value;

  /// The color of the progress indicator.
  /// If null, uses the platform default.
  final Color? color;

  /// The radius of the indicator (iOS only).
  /// Defaults to 10.0.
  final double radius;

  /// The stroke width of the indicator (Android only).
  /// Defaults to 4.0.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return CupertinoActivityIndicator(radius: radius, color: color);
    }

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CircularProgressIndicator(
        value: value,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
