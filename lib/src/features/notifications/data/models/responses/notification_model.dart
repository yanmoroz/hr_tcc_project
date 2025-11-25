import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'author_model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    @JsonKey(name: 'entityID') required int entityId,
    @JsonKey(fromJson: entityTypeFromJson) required EntityType entityType,
    String? parentId,
    String? text,
    String? link,
    required DateTime created,
    required String notificationText,
    required int state,
    AuthorModel? author,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelX on NotificationModel {
  Notification toDomain() => Notification(
    id: id,
    entityId: entityId,
    entityType: entityType,
    parentId: parentId,
    text: text,
    link: link,
    created: created,
    notificationText: notificationText,
    isRead: false,
    author: author?.toDomain(),
  );
}
