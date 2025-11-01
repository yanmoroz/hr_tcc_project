import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';
import 'entity_type.dart';

part 'notification.freezed.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required int id,
    required int entityId,
    required EntityType entityType,
    String? parentId,
    String? text,
    String? link,
    required DateTime created,
    required String notificationText,
    required int state, // 0 = unread, 1 = read
    Author? author,
  }) = _Notification;
}
