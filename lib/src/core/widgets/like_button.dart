import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

import '../../../src/core/extensions/int_extension.dart';
import '../theme/theme.dart';

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
    this.textColor = AppColors.black,
    this.likedColor = AppColors.black,
    this.notLikedColor = AppColors.black,
    this.spacing = 12,
    this.iconSize = 24,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.onPressed,
    super.key,
  });

  final bool isLiked;
  final int likeCount;
  final Color textColor;
  final Color likedColor;
  final Color notLikedColor;
  final double spacing;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = isLiked
        ? SvgPicture.asset(
            Assets.icons.likeWhiteIcon,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(likedColor, BlendMode.srcIn),
          )
        : SvgPicture.asset(
            Assets.icons.likeIcon,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(notLikedColor, BlendMode.srcIn),
          );

    final label = Text(
      likeCount.toFormattedString(),
      style: AppTypography.captionMedium2.black,
    );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: spacing),
        label,
      ],
    );

    // Interactive mode: GestureDetector
    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: row,
      );
    }

    // Display mode: Read-only Row
    return row;
  }
}
