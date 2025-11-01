import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
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
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.notificationsEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        try {
          return itemsJson.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
        } catch (e, stackTrace) {
          print('Error parsing notifications: $e');
          print('StackTrace: $stackTrace');
          rethrow;
        }
      },
    );
  }

  @override
  Future<Either<NetworkException, int>> getUnreadNotificationsCount() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.notificationsCountEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['count'] as int;
      },
    );
  }

  @override
  Future<Either<NetworkException, void>> markAsRead({int? id}) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = id != null ? {'id': id.toString()} : null;
        return _apiClient.post(ApiConstants.notificationsReadEndpoint, queryParameters: queryParameters);
      },
      successParser: (_) => null,
      validStatusCodes: [200, 204],
    );
  }
}
