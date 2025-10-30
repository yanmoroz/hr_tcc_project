import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class ReferralProgramVacancyRemoteDataSource {
  Future<Either<NetworkException, List<ReferralProgramVacancyModel>>> getReferralProgramVacancies({bool? active});
}

class ReferralProgramVacancyRemoteDataSourceImpl implements ReferralProgramVacancyRemoteDataSource {
  final ApiClient _apiClient;

  ReferralProgramVacancyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<ReferralProgramVacancyModel>>> getReferralProgramVacancies({
    bool? active,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.referralProgramVacancyEndpoint,
        queryParameters: active == null ? null : {'active': active},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final vacanciesJson = data['vacancies'] as List<dynamic>;

        final models = vacanciesJson
            .map((json) => ReferralProgramVacancyModel.fromJson(json as Map<String, dynamic>))
            .toList();

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
}
