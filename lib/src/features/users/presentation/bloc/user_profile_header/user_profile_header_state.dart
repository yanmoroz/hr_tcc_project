import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'user_profile_header_state.freezed.dart';

@freezed
class UserProfileHeaderState with _$UserProfileHeaderState {
  const factory UserProfileHeaderState.initial() = UserProfileHeaderInitial;
  const factory UserProfileHeaderState.loading() = UserProfileHeaderLoading;
  const factory UserProfileHeaderState.loaded({required AddressBookUser user}) =
      UserProfileHeaderLoaded;
  const factory UserProfileHeaderState.error(String message) =
      UserProfileHeaderError;
}
