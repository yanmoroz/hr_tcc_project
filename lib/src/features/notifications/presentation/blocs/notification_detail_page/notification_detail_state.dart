import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'notification_detail_state.freezed.dart';

@freezed
class NotificationDetailState with _$NotificationDetailState {
  const factory NotificationDetailState.initial() = NotificationDetailInitial;

  const factory NotificationDetailState.loading() = NotificationDetailLoading;

  const factory NotificationDetailState.loaded({
    required Notification notification,
  }) = NotificationDetailLoaded;

  const factory NotificationDetailState.error(String message) =
      NotificationDetailError;
}
