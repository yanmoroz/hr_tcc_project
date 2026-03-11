import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../theme/theme.dart';
import 'uploading_attachment_state.dart';

class UploadingAttachment extends StatelessWidget {
  final String fileName;
  final UploadingAttachmentState state;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final File? imageFile;
  final bool displayFileName;

  const UploadingAttachment({
    super.key,
    required this.fileName,
    required this.state,
    this.onCancel,
    this.onDelete,
    this.imageFile,
    required this.displayFileName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      child: Column(
        children: [
          Container(
            height: 104,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildContent(context),
          ),
          _buildFileName(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final showThumbnail =
        imageFile != null && state is! UploadingAttachmentError;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showThumbnail)
            Image.file(imageFile!, fit: BoxFit.fill, width: 104, height: 104)
          else
            Center(
              child: Icon(
                Icons.insert_drive_file_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
          if (state is UploadingAttachmentLoading && onCancel != null)
            Center(child: _buildStatusIndicator(context)),
          if (state is UploadingAttachmentSuccess) ...[
            Positioned(top: 4, right: 4, child: _buildDeleteButton(onDelete)),
            Positioned(
              bottom: 4,
              left: 4,
              child: _buildFileSizeBadge(imageFile?.lengthSync() ?? 0),
            ),
          ],
          if (state is UploadingAttachmentError)
            Positioned(top: 4, right: 4, child: _buildDeleteButton(onDelete)),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback? onAction) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onAction,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blue700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SvgPicture.asset(
            Assets.icons.closeBoldIcon,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileName(BuildContext context) {
    if (!displayFileName) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        child: Text(
          fileName.toUpperCase(),
          style: AppTypography.captionMedium2.grey700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildFileSizeBadge(int bytes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _formatFileSize(bytes),
        style: AppTypography.captionMedium3.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildLoadingIndicator(double progress) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue700,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                value: progress > 0 ? min(progress, 0.9) : null,
                strokeWidth: 2,
                color: AppColors.white,
                backgroundColor: AppColors.transparent,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCancel,
              child: SizedBox(
                width: 26,
                height: 26,
                child: _buildDeleteButton(onCancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return switch (state) {
      UploadingAttachmentLoading(:final progress) => _buildLoadingIndicator(
        progress,
      ),
      UploadingAttachmentSuccess() => SizedBox.shrink(),
      UploadingAttachmentError() => SizedBox.shrink(),
    };
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes Б';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} Кб';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Мб';
  }
}
