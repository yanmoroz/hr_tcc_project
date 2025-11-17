import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_header_event.freezed.dart';

@freezed
class UserProfileHeaderEvent with _$UserProfileHeaderEvent {
  const factory UserProfileHeaderEvent.loadUserProfile() = LoadUserProfile;
  const factory UserProfileHeaderEvent.refreshUserProfile() =
      RefreshUserProfile;
}
