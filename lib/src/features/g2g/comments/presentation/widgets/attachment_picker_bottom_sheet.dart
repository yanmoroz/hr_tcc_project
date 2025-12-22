import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../core/theme/theme.dart';

class AttachmentPickerBottomSheet extends StatelessWidget {
  final VoidCallback onPickPhoto;
  final VoidCallback onPickDocument;

  const AttachmentPickerBottomSheet({
    super.key,
    required this.onPickPhoto,
    required this.onPickDocument,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: AppColors.blur.withValues(alpha: 0.15)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    _buildOption(
                      icon: Icons.image_outlined,
                      label: 'Фото',
                      onTap: () {
                        Navigator.of(context).pop();
                        onPickPhoto();
                      },
                    ),
                    const Divider(height: 1, color: AppColors.grey200),
                    _buildOption(
                      svgIcon: Assets.icons.document1Icon,
                      label: 'Документ',
                      onTap: () {
                        Navigator.of(context).pop();
                        onPickDocument();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Выберите файл', style: AppTypography.titleSemibold4),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
              Assets.icons.closeIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.grey700,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    IconData? icon,
    String? svgIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 24, color: AppColors.grey700)
            else if (svgIcon != null)
              SvgPicture.asset(
                svgIcon,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.grey700,
                  BlendMode.srcIn,
                ),
              ),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.textRegular1.black),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onPickPhoto,
    required VoidCallback onPickDocument,
  }) async {
    await showDialog(
      context: context,
      barrierColor: AppColors.transparent,
      useSafeArea: false,
      builder: (dialogContext) => AttachmentPickerBottomSheet(
        onPickPhoto: onPickPhoto,
        onPickDocument: onPickDocument,
      ),
    );
  }
}
