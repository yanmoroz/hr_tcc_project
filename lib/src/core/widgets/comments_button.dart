import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

/// A reusable comments button widget that displays a comment icon with counter.
///
/// This widget can work in two modes:
/// - Interactive mode: When [onPressed] is provided, renders as a GestureDetector
/// - Display mode: When [onPressed] is null, renders as a read-only Row
///
/// The comment icon uses comments-icon.svg and is displayed in white color.
class CommentsButton extends StatelessWidget {
  const CommentsButton({required this.commentCount, this.onPressed, super.key});

  final int commentCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      Assets.icons.commentsIcon,
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );

    final label = Text(
      '$commentCount',
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, const SizedBox(width: 4), label],
    );

    // Interactive mode: GestureDetector
    if (onPressed != null) {
      return GestureDetector(onTap: onPressed, child: row);
    }

    // Display mode: Read-only Row
    return row;
  }
}
