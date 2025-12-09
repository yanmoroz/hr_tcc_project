import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'notifications_list_state.freezed.dart';

@freezed
sealed class NotificationsListState with _$NotificationsListState {
  const factory NotificationsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(LoadingStatus.initial) LoadingStatus markAllAsReadStatus,
    @Default([]) List<Notification> notifications,
    String? errorMessage,
    String? actionError,
  }) = _NotificationsListState;

  const NotificationsListState._();

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;
}
