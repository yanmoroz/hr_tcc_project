import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/theme.dart';

class MenuButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const MenuButton({
    required this.iconPath,
    required this.label,
    required this.onTap,
    super.key,
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
