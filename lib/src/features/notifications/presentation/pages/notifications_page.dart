import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/notifications_page/bloc.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsListBloc, NotificationsListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Уведомления')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotificationsListState state) {
    if (state.status == LoadingStatus.initial) {
      return const Center(child: Text('Нет уведомлений'));
    }

    if (state.status == LoadingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFF757575)),
            const SizedBox(height: 16),
            const Text(
              'Ошибка загрузки',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationsListBloc>().add(
                  const NotificationsListEvent.loadNotifications(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final notifications = state.notifications;
    final unreadCount = state.unreadCount;

    if (notifications.isEmpty) {
      return const Center(child: Text('Нет уведомлений'));
    }

    return Stack(
      children: [
        // Notifications list
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationItem(
              notification: notification,
              onTap: () {
                // Navigate to detail page
                context.push('/notifications/${notification.id}');
              },
            );
          },
        ),

        // Mark all as read button (bottom)
        if (unreadCount > 0)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<NotificationsListBloc>().add(
                      const NotificationsListEvent.markAllAsRead(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF5E6AD2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Отметить все как прочитанные',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
