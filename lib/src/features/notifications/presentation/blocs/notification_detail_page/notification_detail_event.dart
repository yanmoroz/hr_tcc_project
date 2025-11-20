import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_detail_event.freezed.dart';

@freezed
class NotificationDetailEvent with _$NotificationDetailEvent {
  const factory NotificationDetailEvent.loadDetail(int notificationId) =
      LoadDetail;

  const factory NotificationDetailEvent.markAsRead() = MarkAsRead;

  const factory NotificationDetailEvent.refreshDetail() = RefreshDetail;
}
