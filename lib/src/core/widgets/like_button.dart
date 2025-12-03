import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../../../src/core/extensions/int_extension.dart';

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
    this.spacing = 12,
    this.iconSize = 24,
    required this.likedTextStyle,
    required this.notLikedTextStyle,
    required this.likedIconColor,
    required this.notLikedIconColor,
    required this.onPressed,
    super.key,
  });

  final bool isLiked;
  final int likeCount;
  final double spacing;
  final double iconSize;
  final TextStyle likedTextStyle;
  final TextStyle notLikedTextStyle;
  final Color likedIconColor;
  final Color notLikedIconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = isLiked
        ? SvgPicture.asset(
            Assets.icons.likeWhiteIcon,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(likedIconColor, BlendMode.srcIn),
          )
        : SvgPicture.asset(
            Assets.icons.likeIcon,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(notLikedIconColor, BlendMode.srcIn),
          );

    final text = isLiked
        ? Text(likeCount.toFormattedString(), style: likedTextStyle)
        : Text(likeCount.toFormattedString(), style: notLikedTextStyle);

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: spacing),
          text,
        ],
      ),
    );
  }
}
