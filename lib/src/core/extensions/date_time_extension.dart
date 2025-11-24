/// Extension methods for date and time formatting
extension DateTimeExtension on DateTime {
  /// Returns a relative time string in Russian (e.g., "12 дней назад", "2 часа назад")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${_getDaysWord(difference.inDays)} назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${_getHoursWord(difference.inHours)} назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${_getMinutesWord(difference.inMinutes)} назад';
    } else {
      return 'только что';
    }
  }
}

/// Helper functions for Russian pluralization
String _getDaysWord(int days) {
  if (days % 10 == 1 && days % 100 != 11) return 'день';
  if ([2, 3, 4].contains(days % 10) && ![12, 13, 14].contains(days % 100)) {
    return 'дня';
  }
  return 'дней';
}

String _getHoursWord(int hours) {
  if (hours % 10 == 1 && hours % 100 != 11) return 'час';
  if ([2, 3, 4].contains(hours % 10) && ![12, 13, 14].contains(hours % 100)) {
    return 'часа';
  }
  return 'часов';
}

String _getMinutesWord(int minutes) {
  if (minutes % 10 == 1 && minutes % 100 != 11) return 'минуту';
  if ([2, 3, 4].contains(minutes % 10) &&
      ![12, 13, 14].contains(minutes % 100)) {
    return 'минуты';
  }
  return 'минут';
}
