import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_detail_event.freezed.dart';

@freezed
class NotificationDetailEvent with _$NotificationDetailEvent {
  const factory NotificationDetailEvent.loadNotification() = LoadNotification;
  const factory NotificationDetailEvent.markAsReadIfNeeded() =
      MarkAsReadIfNeeded;
}
