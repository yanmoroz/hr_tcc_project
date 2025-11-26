import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

import '../../../src/core/extensions/int_extension.dart';

/// A reusable comments button widget that displays a comment icon with counter.
///
/// This widget can work in two modes:
/// - Interactive mode: When [onPressed] is provided, renders as a GestureDetector
/// - Display mode: When [onPressed] is null, renders as a read-only Row
///
/// The comment icon uses comments-icon.svg and is displayed in white color.
class CommentsButton extends StatelessWidget {
  final int commentCount;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  const CommentsButton({
    required this.commentCount,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      Assets.icons.commentsIcon,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      fit: BoxFit.none,
    );

    final label = Text(
      commentCount.toFormattedString(),
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, const SizedBox(width: 12), label],
    );

    // Interactive mode: GestureDetector
    if (onPressed != null) {
      return GestureDetector(onTap: onPressed, child: row);
    }

    // Display mode: Read-only Row
    return row;
  }
}
