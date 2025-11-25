import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import 'notification_detail_event.dart';
import 'notification_detail_state.dart';

class NotificationDetailBloc
    extends Bloc<NotificationDetailEvent, NotificationDetailState> {
  final Notification notification;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;
  final UpdateNotificationUsecase updateNotificationUsecase;

  NotificationDetailBloc({
    required this.notification,
    required this.markNotificationAsReadUsecase,
    required this.updateNotificationUsecase,
  }) : super(NotificationDetailState(notification: notification)) {
    on<MarkAsReadIfNeeded>(_onMarkAsReadIfNeeded);
    add(const MarkAsReadIfNeeded());
  }

  Future<void> _onMarkAsReadIfNeeded(
    MarkAsReadIfNeeded event,
    Emitter<NotificationDetailState> emit,
  ) async {
    if (notification.isRead) return;

    final result = await markNotificationAsReadUsecase(notification.id);
    result.fold(
      (exception) {
        emit(state.copyWith(notification: notification));
      },
      (_) {
        final updatedNotification = notification.copyWith(isRead: true);
        updateNotificationUsecase.call(updatedNotification);
        emit(state.copyWith(notification: notification.copyWith(isRead: true)));
      },
    );
  }
}
