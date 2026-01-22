import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/entity_type.dart';
import 'author.dart';

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
    required bool isRead,
    Author? author,
  }) = _Notification;
}
