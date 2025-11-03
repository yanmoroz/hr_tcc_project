import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class ReferralProgramVacancyRemoteDataSource {
  Future<Result<List<ReferralProgramVacancyModel>>> getReferralProgramVacancies({bool? active});
}

class ReferralProgramVacancyRemoteDataSourceImpl implements ReferralProgramVacancyRemoteDataSource {
  final ApiClient _apiClient;

  ReferralProgramVacancyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<ReferralProgramVacancyModel>>> getReferralProgramVacancies({
    bool? active,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(
        ApiConstants.referralProgramVacancyEndpoint,
        queryParameters: active == null ? null : {'active': active},
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final vacanciesJson = data['vacancies'] as List<dynamic>;
        return vacanciesJson.map((json) => ReferralProgramVacancyModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
