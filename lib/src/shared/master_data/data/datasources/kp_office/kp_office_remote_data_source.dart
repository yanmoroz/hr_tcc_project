import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpOfficeRemoteDataSource {
  Future<Result<List<KpOfficeModel>>> getKpOffices();
}

class KpOfficeRemoteDataSourceImpl implements KpOfficeRemoteDataSource {
  final ApiClient _apiClient;

  KpOfficeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<KpOfficeModel>>> getKpOffices() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpOfficeEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final officesJson = data['offices'] as List<dynamic>;
        return officesJson.map((json) => KpOfficeModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
