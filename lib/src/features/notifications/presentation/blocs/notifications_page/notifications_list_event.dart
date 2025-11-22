import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_list_event.freezed.dart';

@freezed
class NotificationsListEvent with _$NotificationsListEvent {
  const factory NotificationsListEvent.loadNotifications() = LoadNotifications;
  const factory NotificationsListEvent.markNotificationAsRead(int id) =
      MarkNotificationAsRead;
  const factory NotificationsListEvent.markAllAsRead() = MarkAllAsRead;
}
