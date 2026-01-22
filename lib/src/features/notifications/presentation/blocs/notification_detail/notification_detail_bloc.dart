import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';
import 'notification_detail_event.dart';
import 'notification_detail_state.dart';

class NotificationDetailBloc
    extends Bloc<NotificationDetailEvent, NotificationDetailState> {
  final int notificationId;
  final GetNotificationUsecase getNotificationUsecase;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;

  NotificationDetailBloc({
    required this.notificationId,
    required this.getNotificationUsecase,
    required this.markNotificationAsReadUsecase,
  }) : super(NotificationDetailState(notificationId: notificationId)) {
    on<LoadNotification>(_onLoadNotification);
    on<MarkAsReadIfNeeded>(_onMarkAsReadIfNeeded);
    add(const LoadNotification());
  }

  Future<void> _onLoadNotification(
    LoadNotification event,
    Emitter<NotificationDetailState> emit,
  ) async {
    final notification = getNotificationUsecase(notificationId);

    switch (notification) {
      case null:
        emit(
          state.copyWith(
            status: LoadingStatus.error,
            errorMessage: 'Notification not found',
          ),
        );
        return;
      default:
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            notification: notification,
          ),
        );
        add(const MarkAsReadIfNeeded());
    }
  }

  Future<void> _onMarkAsReadIfNeeded(
    MarkAsReadIfNeeded event,
    Emitter<NotificationDetailState> emit,
  ) async {
    final notification = state.notification;

    if (notification == null || notification.isRead) return;

    final result = await markNotificationAsReadUsecase(notification.id);
    result.fold(
      (exception) => emit(state.copyWith(errorMessage: exception.message)),
      (_) {
        // Local cache is automatically updated by the repository
        final updatedNotification = notification.copyWith(isRead: true);
        emit(state.copyWith(notification: updatedNotification));
      },
    );
  }
}
