import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'notifications_list_event.freezed.dart';

@freezed
class NotificationsListEvent with _$NotificationsListEvent {
  const factory NotificationsListEvent.loadNotifications() = LoadNotifications;
  const factory NotificationsListEvent.refreshNotifications() =
      RefreshNotifications;
  const factory NotificationsListEvent.markAllAsRead() = MarkAllAsRead;
  const factory NotificationsListEvent.notificationsDidUpdate(
    List<Notification> notifications,
  ) = NotificationsDidUpdate;
}
