import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../exceptions/network/network_exception.dart';

class ApiCallExecutor {
  static Future<Either<NetworkException, T>> executeApiCall<T>({
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
          print('Error parsing API response: $e');
          print('StackTrace: $stackTrace');
          rethrow;
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
