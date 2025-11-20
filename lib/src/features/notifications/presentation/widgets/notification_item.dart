import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_html/flutter_html.dart';

import '../../domain/domain.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: Row(
              children: [
                // Unread indicator (green dot)
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(width: 20), // Spacer for read notifications
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timestamp
                      Text(
                        _getRelativeTime(notification.created),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Description (truncated)
                      Html(
                        data: notification.notificationText,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(14),
                            color: const Color(0xFF757575),
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Chevron icon
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF757575),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
