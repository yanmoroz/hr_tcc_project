import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/base_types/loading_status.dart';
import '../../../../../../core/base_types/result.dart';
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
    on<RefreshNotifications>(_onRefreshNotifications);
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

  @override
  Future<void> close() async {
    _notificationsSubscription?.cancel();
    super.close();
  }

  Future<void> _onNotificationsDidUpdate(
    NotificationsDidUpdate event,
    Emitter<NotificationsListState> emit,
  ) async {
    emit(state.copyWith(notifications: event.notifications));
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationsListState> emit,
  ) async {
    await _loadNotifications(emit);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadNotifications(emit);
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationsListState> emit,
  ) async {
    if (state.status != LoadingStatus.success) return;

    // If no unread notifications, no need to update
    if (state.notifications.every((n) => n.isRead)) return;

    // Clear previous action error before starting new action
    emit(state.copyWith(actionError: null));

    final result = await markAllNotificationsAsReadUsecase();

    result.fold(
      (error) => emit(state.copyWith(actionError: error.message)),
      (_) {},
    );
  }

  Future<void> _loadNotifications(Emitter<NotificationsListState> emit) async {
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
            unreadNotificationsCount: notifications
                .where((n) => !n.isRead)
                .length,
          ),
        );
      },
    );
  }
}
