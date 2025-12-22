import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/domain.dart';

class ResellItemCard extends StatelessWidget {
  final ResellItem item;
  final VoidCallback onTap;
  final VoidCallback? onBookPressed;
  final Uint8List? coverImage;

  const ResellItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onBookPressed,
    this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,###', 'ru_RU');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  _buildImage(),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        Text(
                          '${priceFormat.format(item.price)} \u20BD',
                          style: AppTypography.titleBold3.black,
                        ),
                        const SizedBox(height: 4),
                        // Title
                        Text(
                          item.shortName,
                          style: AppTypography.textMedium2.black,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Category
                        Text(
                          item.equipmentType.name,
                          style: AppTypography.textRegular2.black,
                        ),
                        const SizedBox(height: 12),
                        // Author and date
                        ..._buildAuthorAndDate(),
                      ],
                    ),
                  ),
                ],
              ),
              // Book button
              if (onBookPressed != null) ...[
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Забронировать',
                  icon: Assets.icons.unblockIcon,
                  size: PrimaryButtonSize.small,
                  style: PrimatyButtonStyle.colored,
                  onPressed: onBookPressed!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAuthorAndDate() {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final authorName = item.author != null
        ? '${item.author!.lastName} ${item.author!.firstName}'
        : '';
    final dateStr = dateFormat.format(item.creationDate);

    return [
      Text(authorName, style: AppTypography.captionMedium2.grey700),
      const SizedBox(height: 2),
      Text(dateStr, style: AppTypography.captionMedium2.grey700),
    ];
  }

  Widget _buildImage() {
    const width = 100.0;
    const height = 140.0;

    if (coverImage != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey200, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            coverImage!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage(width, height);
            },
          ),
        ),
      );
    }

    return _buildPlaceholderImage(width, height);
  }

  Widget _buildPlaceholderImage(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, size: 40, color: AppColors.grey500),
    );
  }
}
