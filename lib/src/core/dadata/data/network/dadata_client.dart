import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../network/api_client.dart';
import '../../auth/dadata_token_provider.dart';
import '../../dadata_constants.dart';

/// Custom API client for DaData with Token + X-Secret authentication
class DaDataClient implements ApiClient {
  late final Dio _dio;
  final DaDataTokenProvider _tokenProvider;

  DaDataClient(this._tokenProvider) {
    _initialize();
  }

  // Other ApiClient methods throw UnimplementedError (not needed for DaData)
  @override
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    throw UnimplementedError('DELETE not supported by DaData API');
  }

  @override
  Future<Response> downloadFile(
    String path, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) {
    throw UnimplementedError('File download not supported by DaData API');
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    throw UnimplementedError('PUT not supported by DaData API');
  }

  @override
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  }) {
    throw UnimplementedError('File upload not supported by DaData API');
  }

  void _initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: DaDataConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          DaDataConstants.contentTypeHeader: DaDataConstants.jsonContentType,
          DaDataConstants.acceptHeader: DaDataConstants.jsonContentType,
        },
      ),
    );

    // Add DaData auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider.token;
          final secret = _tokenProvider.secret;

          if (token != null) {
            options.headers[DaDataConstants.authorizationHeader] =
                'Token $token';
          }
          if (secret != null) {
            options.headers[DaDataConstants.secretHeader] = secret;
          }

          handler.next(options);
        },
      ),
    );

    // Add logging interceptor
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
}
