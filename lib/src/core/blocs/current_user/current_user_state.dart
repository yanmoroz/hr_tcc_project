import 'package:freezed_annotation/freezed_annotation.dart';

import '../../base_types/loading_status.dart';
import '../../../features/g2g/users/domain/domain.dart';

part 'current_user_state.freezed.dart';

@freezed
sealed class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    AddressBookUser? user,
    String? errorMessage,
  }) = _CurrentUserState;
}
