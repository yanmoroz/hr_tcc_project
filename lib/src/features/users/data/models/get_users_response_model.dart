import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'get_users_response_model.freezed.dart';
part 'get_users_response_model.g.dart';

@freezed
abstract class GetUsersResponseModel with _$GetUsersResponseModel {
  const factory GetUsersResponseModel({required List<UserModel> users}) =
      _GetUsersResponseModel;

  factory GetUsersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetUsersResponseModelFromJson(json);
}
