import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../data.dart';

abstract class ResellEquipmentTypeRemoteDataSource {
  Future<Result<List<ResellEquipmentTypeModel>>> getResellEquipmentTypes();
}

class ResellEquipmentTypeRemoteDataSourceImpl implements ResellEquipmentTypeRemoteDataSource {
  final ApiClient _apiClient;

  ResellEquipmentTypeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<ResellEquipmentTypeModel>>> getResellEquipmentTypes() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.resellEquipmentTypeEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final equipmentTypesJson = data['equipmentTypes'] as List<dynamic>;
        return equipmentTypesJson
            .map((json) => ResellEquipmentTypeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
