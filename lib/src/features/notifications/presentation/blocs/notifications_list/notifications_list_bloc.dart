import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../domain/domain.dart';

import 'notifications_list_event.dart';
import 'notifications_list_state.dart';

class NotificationsListBloc
    extends Bloc<NotificationsListEvent, NotificationsListState> {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkAllNotificationsAsReadUsecase markAllNotificationsAsReadUsecase;
  final WatchNotificationsUseCase watchNotificationsUseCase;
  StreamSubscription<List<Notification>>? _notificationsSubscription;

  NotificationsListBloc({
    required this.getNotificationsUsecase,
    required this.markAllNotificationsAsReadUsecase,
    required this.watchNotificationsUseCase,
  }) : super(const NotificationsListState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<NotificationsDidUpdate>(_onNotificationsDidUpdate);

    _notificationsSubscription = watchNotificationsUseCase().listen((
      notifications,
    ) {
      // Only emit if BLoC is still open
      if (!isClosed) {
        add(NotificationsDidUpdate(notifications));
      }
    });
  }

  Future<void> _onNotificationsDidUpdate(
    NotificationsDidUpdate event,
    Emitter<NotificationsListState> emit,
  ) async {
    emit(state.copyWith(notifications: event.notifications));
  }

  @override
  Future<void> close() async {
    _notificationsSubscription?.cancel();
    super.close();
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final notificationsResult = await getNotificationsUsecase();

    await notificationsResult.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (notifications) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            notifications: notifications,
          ),
        );
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationsListState> emit,
  ) async {
    if (state.status != LoadingStatus.success) return;

    // If no unread notifications, no need to update
    if (state.notifications
        .where((notification) => !notification.isRead)
        .isEmpty)
      return;

    final result = await markAllNotificationsAsReadUsecase();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (_) {
        // Update local state: mark all notifications as read
        final updatedNotifications = state.notifications.map((notification) {
          if (!notification.isRead) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        // Update unread count: set to 0
        emit(state.copyWith(notifications: updatedNotifications));
      },
    );
  }
}
