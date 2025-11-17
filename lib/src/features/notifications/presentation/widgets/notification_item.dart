import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_html/flutter_html.dart';

import '../../domain/domain.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  final VoidCallback onMarkAsRead;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.text != null &&
                (notification.text?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Html(
                  data: notification.text!,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(
                        Theme.of(context).textTheme.titleMedium?.fontSize ??
                            16.0,
                      ),
                      fontWeight:
                          Theme.of(context).textTheme.titleMedium?.fontWeight,
                    ),
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Html(
                data: notification.notificationText,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(
                      Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0,
                    ),
                    fontWeight:
                        Theme.of(context).textTheme.bodyMedium?.fontWeight,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Type: ${notification.entityType.value}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (!notification.isRead)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onMarkAsRead,
                  child: const Text('Mark As Read'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
