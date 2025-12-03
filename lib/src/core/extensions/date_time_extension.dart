import 'package:intl/intl.dart';

import '../utils/pluralization.dart';

/// Extension methods for date and time formatting
extension DateTimeExtension on DateTime {
  /// Returns a relative time string in Russian (e.g., "12 дней назад", "2 часа назад")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      final days = difference.inDays;
      return pluralizeRu(days, '$days день', '$days дня', '$days дней') +
          ' назад';
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      return pluralizeRu(hours, '$hours час', '$hours часа', '$hours часов') +
          ' назад';
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return pluralizeRu(
            minutes,
            '$minutes минуту',
            '$minutes минуты',
            '$minutes минут',
          ) +
          ' назад';
    } else {
      return 'только что';
    }
  }

  /// Returns a formatted date-time string in Russian
  /// Shows "Сегодня в HH:mm" for today, otherwise "dd.MM.yyyy в HH:mm"
  String toFormattedDateTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(year, month, day);

    final timeFormat = DateFormat('HH:mm');

    if (dateToCheck == today) {
      return 'Сегодня в ${timeFormat.format(this)}';
    } else {
      return '${DateFormat('dd.MM.yyyy').format(this)} в ${timeFormat.format(this)}';
    }
  }

  /// Checks if this DateTime is on the same day as [other]
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if this DateTime is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return isSameDay(yesterday);
  }
}
