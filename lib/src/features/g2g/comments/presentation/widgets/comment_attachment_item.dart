import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../core/theme/theme.dart';
import '../../domain/domain.dart';

class CommentAttachmentItem extends StatelessWidget {
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
  static const _imageSize = 85.0;
  final Attachment attachment;
  final VoidCallback? onTap;

  final Uint8List? imageData;

  const CommentAttachmentItem({
    super.key,
    required this.attachment,
    this.onTap,
    this.imageData,
  });

  bool get _isImage {
    return _imageExtensions.contains(attachment.extension.toLowerCase()) ||
        attachment.thumbnail != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _isImage ? _buildImageAttachment() : _buildFileAttachment(),
    );
  }

  Widget _buildFileAttachment() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue700,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              Assets.icons.document1Icon,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                attachment.name,
                style: AppTypography.textSemibold2.blue700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _formatFileSize(attachment.size),
                style: AppTypography.captionMedium3.grey500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageAttachment() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (imageData != null)
              Image.memory(
                imageData!,
                width: _imageSize,
                height: _imageSize,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
              )
            else
              Image.network(
                attachment.thumbnail ?? attachment.url,
                width: _imageSize,
                height: _imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoading();
                },
              ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.blue700.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatFileSize(attachment.size),
                  style: AppTypography.captionMedium3.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoading() {
    return Container(
      width: _imageSize,
      height: _imageSize,
      color: AppColors.grey200,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.blue700,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: _imageSize,
      height: _imageSize,
      color: AppColors.grey200,
      child: const Icon(Icons.broken_image_outlined, color: AppColors.grey500),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes Б';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} Кб';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Мб';
  }
}
