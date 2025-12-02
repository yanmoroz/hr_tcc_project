import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_user_event.freezed.dart';

@freezed
class CurrentUserEvent with _$CurrentUserEvent {
  const factory CurrentUserEvent.loadCurrentUser() = LoadCurrentUser;
}
