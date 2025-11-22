import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';
import 'notification_detail_event.dart';
import 'notification_detail_state.dart';

class NotificationDetailBloc
    extends Bloc<NotificationDetailEvent, NotificationDetailState> {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;

  int? _currentNotificationId;
  Notification? _currentNotification;

  NotificationDetailBloc({
    required this.getNotificationsUsecase,
    required this.markNotificationAsReadUsecase,
  }) : super(const NotificationDetailState()) {
    on<LoadDetail>(_onLoadDetail);
    on<MarkAsRead>(_onMarkAsRead);
    on<RefreshDetail>(_onRefreshDetail);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<NotificationDetailState> emit,
  ) async {
    _currentNotificationId = event.notificationId;
    emit(state.copyWith(status: LoadingStatus.loading));

    // Fetch all notifications and filter by ID
    final result = await getNotificationsUsecase();

    result.fold(
      (exception) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: exception.toString(),
      )),
      (notifications) {
        try {
          final notification = notifications.firstWhere(
            (n) => n.id == event.notificationId,
          );
          _currentNotification = notification;
          emit(state.copyWith(
            status: LoadingStatus.success,
            notification: notification,
          ));

          // Automatically mark as read if unread
          if (!notification.isRead) {
            add(const NotificationDetailEvent.markAsRead());
          }
        } catch (e) {
          emit(state.copyWith(
            status: LoadingStatus.error,
            errorMessage: 'Уведомление не найдено',
          ));
        }
      },
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationDetailState> emit,
  ) async {
    if (_currentNotificationId == null || _currentNotification == null) return;

    // Optimistically update the notification to mark it as read
    final updatedNotification = _currentNotification!.copyWith(isRead: true);
    _currentNotification = updatedNotification;

    // Update UI optimistically
    emit(state.copyWith(notification: updatedNotification));

    // Mark as read on backend
    final result =
        await markNotificationAsReadUsecase(_currentNotificationId!);

    result.fold(
      (exception) {
        // Rollback on error
        final revertedNotification = updatedNotification.copyWith(isRead: false);
        _currentNotification = revertedNotification;
        emit(state.copyWith(notification: revertedNotification));
      },
      (_) {
        // Success - notification stays marked as read
      },
    );
  }

  Future<void> _onRefreshDetail(
    RefreshDetail event,
    Emitter<NotificationDetailState> emit,
  ) async {
    if (_currentNotificationId == null) return;

    // Re-fetch the notification
    add(NotificationDetailEvent.loadDetail(_currentNotificationId!));
  }
}
