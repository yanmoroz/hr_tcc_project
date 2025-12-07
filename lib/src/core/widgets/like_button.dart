import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../../../src/core/extensions/int_extension.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final double spacing;
  final double iconSize;
  final TextStyle likedTextStyle;
  final TextStyle notLikedTextStyle;
  final Color likedIconColor;
  final Color notLikedIconColor;
  final VoidCallback onPressed;

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

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: spacing),
          Text(
            likeCount.toFormattedString(),
            style: isLiked ? likedTextStyle : notLikedTextStyle,
          ),
        ],
      ),
    );
  }
}
