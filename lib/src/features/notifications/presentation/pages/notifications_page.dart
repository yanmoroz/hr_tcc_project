import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/bloc_factory.dart';
import '../bloc/notifications_page/notifications_list_bloc.dart';
import '../bloc/notifications_page/notifications_list_event.dart';
import '../bloc/notifications_page/notifications_list_state.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BlocFactory.createNotificationsListBloc()..add(const NotificationsListEvent.loadNotifications()),
      child: BlocBuilder<NotificationsListBloc, NotificationsListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.maybeWhen(
                loaded: (notifications, unreadCount) => Text('Notifications ($unreadCount unread)'),
                orElse: () => const Text('Notifications'),
              ),
              actions: [
                state.maybeWhen(
                  loaded: (notifications, unreadCount) {
                    if (unreadCount > 0) {
                      return IconButton(
                        icon: const Icon(Icons.done_all),
                        onPressed: () {
                          context.read<NotificationsListBloc>().add(const NotificationsListEvent.markAllAsRead());
                        },
                        tooltip: 'Mark All As Read',
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            body: state.when(
              initial: () => const Center(child: Text('No notifications')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (notifications, unreadCount) {
                if (notifications.isEmpty) {
                  return const Center(child: Text('No notifications available'));
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationItem(
                      notification: notification,
                      onMarkAsRead: () {
                        context.read<NotificationsListBloc>().add(NotificationsListEvent.markAsRead(notification.id));
                      },
                    );
                  },
                );
              },
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationsListBloc>().add(const NotificationsListEvent.loadNotifications());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
