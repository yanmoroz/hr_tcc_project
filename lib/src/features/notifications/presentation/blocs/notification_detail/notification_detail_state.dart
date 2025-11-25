import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'notification_detail_state.freezed.dart';

@freezed
sealed class NotificationDetailState with _$NotificationDetailState {
  const factory NotificationDetailState({required Notification notification}) =
      _NotificationDetailState;
}
