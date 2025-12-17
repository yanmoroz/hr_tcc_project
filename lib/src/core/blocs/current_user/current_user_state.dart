import 'package:freezed_annotation/freezed_annotation.dart';

import '../../base_types/loading_status.dart';
import '../../entities/current_user.dart';

part 'current_user_state.freezed.dart';

@freezed
sealed class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    CurrentUser? user,
    String? errorMessage,
  }) = _CurrentUserState;
}
