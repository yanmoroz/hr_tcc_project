import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpAbsenceCategoryRemoteDataSource {
  Future<Either<NetworkException, List<KpAbsenceCategoryModel>>> getKpAbsenceCategories();
}

class KpAbsenceCategoryRemoteDataSourceImpl implements KpAbsenceCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpAbsenceCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpAbsenceCategoryModel>>> getKpAbsenceCategories() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpAbsenceCategoryEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final absenceCategoriesJson = data['absenceCategories'] as List<dynamic>;
        return absenceCategoriesJson
            .map((json) => KpAbsenceCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
