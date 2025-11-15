import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../exceptions/mapping/mapping_exception.dart';
import '../exceptions/network/network_exception.dart';
import '../logging/app_logger.dart';
import '../base_types/result.dart';

class ApiCallExecutor {
  static Future<Result<T>> executeApiCall<T>({
    required Future<Response> Function() apiCall,
    required T Function(Response) successParser,
    List<int>? validStatusCodes,
  }) async {
    try {
      final response = await apiCall();
      final validCodes = validStatusCodes ?? [200];

      if (validCodes.contains(response.statusCode)) {
        try {
          return Right(successParser(response));
        } catch (e, stackTrace) {
          AppLogger.e('Error parsing API response', e, stackTrace);
          return Left(MappingException.fromParsingError(e, stackTrace));
        }
      } else {
        return Left(
          NetworkException.fromDioError(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
        NetworkException.fromDioError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: e,
            type: DioExceptionType.unknown,
          ),
        ),
      );
    }
  }
}
