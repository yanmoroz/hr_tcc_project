import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/theme.dart';

class QuickLinkButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const QuickLinkButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.blue700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(iconPath, fit: BoxFit.none),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.captionMedium4.grey700,
            ),
          ),
        ],
      ),
    );
  }
}
