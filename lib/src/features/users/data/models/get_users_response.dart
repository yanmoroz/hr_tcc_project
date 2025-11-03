import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/users/data/models/user_model.dart';

part 'get_users_response.freezed.dart';
part 'get_users_response.g.dart';

@freezed
abstract class GetUsersResponse with _$GetUsersResponse {
  const factory GetUsersResponse({required List<UserModel> users}) = _GetUsersResponse;

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) => _$GetUsersResponseFromJson(json);
}
