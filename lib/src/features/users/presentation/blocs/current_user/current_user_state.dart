import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'current_user_state.freezed.dart';

@freezed
class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState.initial() = CurrentUserInitial;
  const factory CurrentUserState.loading() = CurrentUserLoading;
  const factory CurrentUserState.loaded({required AddressBookUser user}) =
      CurrentUserLoaded;
  const factory CurrentUserState.error(String message) = CurrentUserError;
}
