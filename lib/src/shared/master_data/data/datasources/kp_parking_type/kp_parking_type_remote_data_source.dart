import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpParkingTypeRemoteDataSource {
  Future<Either<NetworkException, List<KpParkingTypeModel>>> getKpParkingTypes();
}

class KpParkingTypeRemoteDataSourceImpl implements KpParkingTypeRemoteDataSource {
  final ApiClient _apiClient;

  KpParkingTypeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpParkingTypeModel>>> getKpParkingTypes() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpParkingTypeEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final parkingTypesJson = data['parkingTypes'] as List<dynamic>;
        return parkingTypesJson.map((json) => KpParkingTypeModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
