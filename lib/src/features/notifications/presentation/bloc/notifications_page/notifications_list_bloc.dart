import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/result.dart';
import '../../../domain/domain.dart';
import 'notifications_list_event.dart';
import 'notifications_list_state.dart';

class NotificationsListBloc
    extends Bloc<NotificationsListEvent, NotificationsListState> {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;
  final MarkAllNotificationsAsReadUsecase markAllNotificationsAsReadUsecase;
  final GetUnreadNotificationsCountUsecase getUnreadNotificationsCountUsecase;

  NotificationsListBloc({
    required this.getNotificationsUsecase,
    required this.markNotificationAsReadUsecase,
    required this.markAllNotificationsAsReadUsecase,
    required this.getUnreadNotificationsCountUsecase,
  }) : super(const NotificationsListState.initial()) {
    on<NotificationsListEvent>((event, emit) async {
      await event.when(
        loadNotifications: () => _onLoadNotifications(emit),
        markAsRead: (id) => _onMarkAsRead(id, emit),
        markAllAsRead: () => _onMarkAllAsRead(emit),
      );
    });
  }

  Future<void> _onLoadNotifications(
    Emitter<NotificationsListState> emit,
  ) async {
    emit(const NotificationsListState.loading());

    // Run both API calls in parallel
    final results = await Future.wait([
      getNotificationsUsecase(),
      getUnreadNotificationsCountUsecase(),
    ]);

    final notificationsResult = results[0] as Result<List<Notification>>;
    final countResult = results[1] as Result<int>;

    notificationsResult.fold(
      (error) => emit(NotificationsListState.error(error.message)),
      (notifications) {
        countResult.fold(
          (error) => emit(NotificationsListState.error(error.message)),
          (unreadCount) => emit(
            NotificationsListState.loaded(
              notifications: notifications,
              unreadCount: unreadCount,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMarkAsRead(
    int id,
    Emitter<NotificationsListState> emit,
  ) async {
    final currentState = state.maybeWhen(
      loaded: (notifications, unreadCount) =>
          (notifications: notifications, unreadCount: unreadCount),
      orElse: () => null,
    );

    if (currentState == null) {
      emit(NotificationsListState.error('Notifications not loaded yet'));
      return;
    }

    final notification = currentState.notifications.firstWhereOrNull(
      (n) => n.id == id,
    );
    if (notification == null) {
      emit(NotificationsListState.error('Notification not found'));
      return;
    }

    // If already read, no need to update
    if (notification.isRead) return;

    final result = await markNotificationAsReadUsecase(id);

    result.fold((error) => emit(NotificationsListState.error(error.message)), (
      _,
    ) {
      // Update local state: mark notification as read
      final updatedNotifications = currentState.notifications.map((
        notification,
      ) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      // Update unread count: decrease by 1
      final updatedUnreadCount = currentState.unreadCount - 1;

      emit(
        NotificationsListState.loaded(
          notifications: updatedNotifications,
          unreadCount: updatedUnreadCount,
        ),
      );
    });
  }

  Future<void> _onMarkAllAsRead(Emitter<NotificationsListState> emit) async {
    final currentState = state.maybeWhen(
      loaded: (notifications, unreadCount) =>
          (notifications: notifications, unreadCount: unreadCount),
      orElse: () => null,
    );

    if (currentState == null) return;

    // If no unread notifications, no need to update
    if (currentState.unreadCount == 0) return;

    final result = await markAllNotificationsAsReadUsecase();

    result.fold((error) => emit(NotificationsListState.error(error.message)), (
      _,
    ) {
      // Update local state: mark all notifications as read
      final updatedNotifications = currentState.notifications.map((
        notification,
      ) {
        if (!notification.isRead) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      // Update unread count: set to 0
      emit(
        NotificationsListState.loaded(
          notifications: updatedNotifications,
          unreadCount: 0,
        ),
      );
    });
  }
}
