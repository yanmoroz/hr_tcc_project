import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../blocs/notification_detail_page/bloc.dart';

class NotificationDetailPage extends StatelessWidget {
  final int notificationId;

  const NotificationDetailPage({super.key, required this.notificationId});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<NotificationDetailBloc, NotificationDetailState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              // Trigger loading on initial state
              context.read<NotificationDetailBloc>().add(
                    NotificationDetailEvent.loadDetail(notificationId),
                  );
              return const Center(child: CircularProgressIndicator());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (notification) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationDetailBloc>().add(
                        const NotificationDetailEvent.refreshDetail(),
                      );
                  // Wait a moment for the refresh
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Timestamp
                    Text(
                      _getRelativeTime(notification.created),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title (if available)
                    if (notification.text != null &&
                        (notification.text?.isNotEmpty ?? false)) ...[
                      Html(
                        data: notification.text!,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Description
                    Html(
                      data: notification.notificationText,
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(16),
                          color: const Color(0xFF212121),
                          lineHeight: const LineHeight(1.5),
                        ),
                      },
                    ),
                  ],
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFF757575),
                  ),
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
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationDetailBloc>().add(
                            const NotificationDetailEvent.refreshDetail(),
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
            ),
          );
        },
      ),
    );
  }
}
