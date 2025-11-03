import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class StaffRemoteDataSource {
  Future<Result<List<StaffItemModel>>> getStaff({required StaffTarget target, String? search});
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final ApiClient _apiClient;

  StaffRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<StaffItemModel>>> getStaff({required StaffTarget target, String? search}) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, String>{'target': target.value};
        if (search != null && search.isNotEmpty) {
          queryParameters['search'] = search;
        }
        return _apiClient.get(ApiConstants.staffEndpoint, queryParameters: queryParameters);
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        return itemsJson.map((json) => StaffItemModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
