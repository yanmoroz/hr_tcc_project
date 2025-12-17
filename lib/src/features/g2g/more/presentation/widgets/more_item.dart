import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';

class MoreItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback onTap;

  const MoreItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 30,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(title, style: AppTypography.textMedium1.black),

                  // Subtitle (if provided)
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: AppTypography.textRegular2.grey700),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Icon (if provided) or chevron
            if (icon != null)
              Container(child: icon)
            else
              // Chevron icon (only shown when no icon provided)
              Icon(Icons.chevron_right, color: AppColors.grey700, size: 24),
          ],
        ),
      ),
    );
  }
}
