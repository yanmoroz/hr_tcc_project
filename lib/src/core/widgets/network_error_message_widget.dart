import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../retry/retry_notifier.dart';
import '../theme/theme.dart';

class NetworkErrorMessageWidget extends StatelessWidget {
  const NetworkErrorMessageWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  void _handleRetry(BuildContext context) {
    onRetry();
    context.read<RetryNotifier>().notifyRetry();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Не удалось получить данные. Сервер может быть временно недоступен.',
              style: AppTypography.textRegular1.copyWith(color: AppColors.grey700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _handleRetry(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Повторить',
                style: AppTypography.buttonMedium1.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
