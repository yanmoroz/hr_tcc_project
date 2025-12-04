import 'package:flutter/material.dart';

/// A text button that removes all default padding and styling.
///
/// This widget wraps [TextButton] and removes:
/// - Default padding
/// - Minimum size constraints
/// - Rounded border/shape
///
/// Useful for inline text links that should behave like plain text.
class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;
  final ButtonStyle? style;
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(),
      ).merge(style),
      child: child,
    );
  }
}
