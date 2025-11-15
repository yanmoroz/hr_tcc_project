import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Result<List<NotificationModel>>> getNotifications();
  Future<Result<int>> getUnreadNotificationsCount();
  Future<Result<void>> markAsRead({int? id});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<NotificationModel>>> getNotifications() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.notificationsEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        return itemsJson
            .map(
              (json) =>
                  NotificationModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<int>> getUnreadNotificationsCount() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.notificationsCountEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['count'] as int;
      },
    );
  }

  @override
  Future<Result<void>> markAsRead({int? id}) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = id != null ? {'id': id.toString()} : null;
        return _apiClient.post(
          ApiConstants.notificationsReadEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (_) => null,
      validStatusCodes: [200, 204],
    );
  }
}
