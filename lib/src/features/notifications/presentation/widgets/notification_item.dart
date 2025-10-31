import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart' as domain;

class NotificationItem extends StatelessWidget {
  final domain.Notification notification;
  final VoidCallback onMarkAsRead;

  const NotificationItem({super.key, required this.notification, required this.onMarkAsRead});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.text != null && (notification.text?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(notification.text!, style: Theme.of(context).textTheme.titleMedium),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(notification.notificationText, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Type: ${notification.entityType.value}', style: Theme.of(context).textTheme.bodySmall),
            ),
            if (notification.state == 0)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(onPressed: onMarkAsRead, child: const Text('Mark As Read')),
              ),
          ],
        ),
      ),
    );
  }
}
