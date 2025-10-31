import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<NetworkException, List<NotificationModel>>> getNotifications();
  Future<Either<NetworkException, int>> getUnreadNotificationsCount();
  Future<Either<NetworkException, void>> markAsRead({int? id});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await _apiClient.get(ApiConstants.notificationsEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;

        final models = itemsJson.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();

        return Right(models);
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

  @override
  Future<Either<NetworkException, int>> getUnreadNotificationsCount() async {
    try {
      final response = await _apiClient.get(ApiConstants.notificationsCountEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final count = data['count'] as int;

        return Right(count);
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

  @override
  Future<Either<NetworkException, void>> markAsRead({int? id}) async {
    try {
      final queryParameters = id != null ? {'id': id.toString()} : null;
      final response = await _apiClient.post(ApiConstants.notificationsReadEndpoint, queryParameters: queryParameters);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
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
