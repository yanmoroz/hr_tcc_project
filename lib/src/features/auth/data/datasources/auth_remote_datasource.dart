import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/keycloak_api_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/refresh_token_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<AuthResponseModel>> login({
    required String username,
    required String password,
  });

  Future<Result<AuthResponseModel>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final KeycloakApiClient _keycloakClient;

  AuthRemoteDataSourceImpl(this._keycloakClient);

  @override
  Future<Result<AuthResponseModel>> login({
    required String username,
    required String password,
  }) async {
    final requestModel = LoginRequestModel(
      username: username,
      password: password,
      clientId: ApiConstants.keycloakClientId,
      clientSecret: ApiConstants.keycloakClientSecret,
    );

    return ApiCallExecutor.executeApiCall(
      apiCall: () => _keycloakClient.post(
        ApiConstants.keycloakTokenEndpoint,
        data: _toFormData(requestModel.toJson()),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return AuthResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<AuthResponseModel>> refreshToken(String refreshToken) async {
    final requestModel = RefreshTokenRequestModel(
      refreshToken: refreshToken,
      clientId: ApiConstants.keycloakClientId,
      clientSecret: ApiConstants.keycloakClientSecret,
    );

    return ApiCallExecutor.executeApiCall(
      apiCall: () => _keycloakClient.post(
        ApiConstants.keycloakTokenEndpoint,
        data: _toFormData(requestModel.toJson()),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return AuthResponseModel.fromJson(data);
      },
    );
  }

  /// Converts JSON map to form data by removing null values
  /// Dio will automatically encode this as application/x-www-form-urlencoded
  Map<String, dynamic> _toFormData(Map<String, dynamic> json) {
    return Map.fromEntries(
      json.entries.where((e) => e.value != null),
    );
  }
}
