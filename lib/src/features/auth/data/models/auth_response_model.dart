import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_tokens.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'refresh_expires_in') int? refreshExpiresIn,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    String? scope,
    @JsonKey(name: 'session_state') String? sessionState,
    @JsonKey(name: 'not-before-policy') int? notBeforePolicy,
  }) = _AuthResponseModel;

  const AuthResponseModel._();

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  AuthTokens toDomain() {
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }
}
