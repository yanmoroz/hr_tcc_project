import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/primary_button.dart';

/// Success dialog shown after completing a poll
class PollSuccessDialog extends StatelessWidget {
  const PollSuccessDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) => const PollSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 325,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Waving hand emoji with sparkles
            const Text('👋', style: TextStyle(fontSize: 64)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('✨', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('✨', style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Спасибо за участие!',
              style: AppTypography.titleSemibold3.copyWith(
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Ваши ответы помогают улучшать наш сервис',
              style: AppTypography.textRegular2.copyWith(
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Close button
            PrimaryButton(
              label: 'Пожалуйста',
              size: PrimaryButtonSize.large,
              style: PrimatyButtonStyle.colored,
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to polls list
              },
            ),
          ],
        ),
      ),
    );
  }
}
