import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../auth/auth_token_provider.dart';
import 'api_constants.dart';

abstract class ApiClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  });
  Future<Response> downloadFile(
    String path, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    Options? options,
  });
}

abstract class BaseApiClient implements ApiClient {
  late final Dio _dio;
  final AuthTokenProvider _authTokenProvider;

  BaseApiClient(this._authTokenProvider) {
    _initialize();
  }

  void _initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {ApiConstants.acceptHeader: ApiConstants.acceptValue},
      ),
    );

    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _authTokenProvider.token;
          if (token != null) {
            options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // Add logging interceptor for debugging
    // Suppress logging for file upload/download requests to avoid excessive logging of binary data
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        filter: (options, args) {
          // Skip logging for file upload/download endpoints
          final path = options.path.toLowerCase();
          return !path.contains('/files/upload') && !path.contains('/files/download');
        },
      ),
    );

    // Configure insecure certificate callback if needed
    _configureCertificateValidation();
  }

  /// Override this method to configure certificate validation behavior
  void _configureCertificateValidation() {
    // Default: secure (no override needed)
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  }) {
    return _dio.post(path, data: formData, queryParameters: queryParameters, onSendProgress: onSendProgress);
  }

  @override
  Future<Response> downloadFile(
    String path, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      options:
          options ??
          Options(responseType: ResponseType.bytes, followRedirects: false, validateStatus: (status) => status! < 500),
    );
  }
}

class SecureApiClient extends BaseApiClient {
  SecureApiClient(super._authTokenProvider);
}

class InsecureApiClient extends BaseApiClient {
  InsecureApiClient(super._authTokenProvider);

  @override
  void _configureCertificateValidation() {
    // Configure HTTP client adapter for insecure connections
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
