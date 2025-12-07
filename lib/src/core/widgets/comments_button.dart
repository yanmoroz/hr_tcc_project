import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../../../src/core/extensions/int_extension.dart';
import '../theme/theme.dart';

class CommentsButton extends StatelessWidget {
  final int commentCount;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  const CommentsButton({
    required this.commentCount,
    this.textColor = AppColors.black,
    this.iconColor = AppColors.black,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.icons.commentsIcon,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          fit: BoxFit.none,
        ),
        const SizedBox(width: 12),
        Text(
          commentCount.toFormattedString(),
          style: AppTypography.captionMedium2.black,
        ),
      ],
    );

    return onPressed != null
        ? GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: row,
          )
        : row;
  }
}
