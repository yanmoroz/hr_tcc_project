import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'notifications_list_state.freezed.dart';

@freezed
class NotificationsListState with _$NotificationsListState {
  const factory NotificationsListState.initial() = NotificationsListInitial;
  const factory NotificationsListState.loading() = NotificationsListLoading;
  const factory NotificationsListState.loaded({required List<Notification> notifications, required int unreadCount}) =
      NotificationsListLoaded;
  const factory NotificationsListState.error(String message) = NotificationsListError;
}
