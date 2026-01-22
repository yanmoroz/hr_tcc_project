import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'notification_detail_state.freezed.dart';

@freezed
sealed class NotificationDetailState with _$NotificationDetailState {
  const factory NotificationDetailState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    required int notificationId,
    Notification? notification,
    String? errorMessage,
  }) = _NotificationDetailState;
}
