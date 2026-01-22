import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';

/// Lightweight API client for Keycloak OAuth2/OIDC token requests
/// Only provides POST method since OAuth2 token flows only use POST
class KeycloakApiClient {
  late final Dio _dio;

  KeycloakApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.keycloakBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    // Add logging interceptor for debugging OAuth flows
    _dio.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  /// POST request for OAuth2 token endpoints
  /// Dio automatically sends Map data as application/x-www-form-urlencoded
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }
}
