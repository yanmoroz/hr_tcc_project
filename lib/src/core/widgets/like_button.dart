import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A reusable like button widget that displays a like icon with counter.
///
/// This widget can work in two modes:
/// - Interactive mode: When [onPressed] is provided, renders as a GestureDetector
/// - Display mode: When [onPressed] is null, renders as a read-only Row
///
/// The like icon changes based on [isLiked]:
/// - like-white-icon.svg when liked
/// - like-icon.svg when not liked
/// Both icons are displayed in white color.
class LikeButton extends StatelessWidget {
  const LikeButton({
    required this.isLiked,
    required this.likeCount,
    this.onPressed,
    super.key,
  });

  final bool isLiked;
  final int likeCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = isLiked
        ? SvgPicture.asset(
            'assets/icons/like-white-icon.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          )
        : SvgPicture.asset(
            'assets/icons/like-icon.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          );

    final label = Text(
      '$likeCount',
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
