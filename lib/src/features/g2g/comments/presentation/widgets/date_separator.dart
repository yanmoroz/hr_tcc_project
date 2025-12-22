import 'package:flutter/material.dart';

import '../../../../../core/extensions/date_time_extension.dart';
import '../../../../../core/theme/theme.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.shadow.withValues(alpha: 0.40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _formatDate(date),
          style: AppTypography.captionMedium2.white,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.isSameDay(DateTime.now())) {
      return 'Сегодня';
    }

    if (date.isYesterday()) {
      return 'Вчера';
    }

    final day = date.day;
    final month = _getRussianMonth(date.month);
    return '$day $month';
  }

  String _getRussianMonth(int month) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return months[month - 1];
  }
}
