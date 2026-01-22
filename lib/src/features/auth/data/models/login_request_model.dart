import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    @JsonKey(name: 'grant_type') @Default('password') String grantType,
    required String username,
    required String password,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'client_secret') required String clientSecret,
    String? scope,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}
