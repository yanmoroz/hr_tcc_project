import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class ViolationSecurityLevelRemoteDataSource {
  Future<Either<NetworkException, List<ViolationSecurityLevelModel>>> getViolationSecurityLevels();
}

class ViolationSecurityLevelRemoteDataSourceImpl implements ViolationSecurityLevelRemoteDataSource {
  final ApiClient _apiClient;

  ViolationSecurityLevelRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<ViolationSecurityLevelModel>>> getViolationSecurityLevels() async {
    try {
      final response = await _apiClient.get(ApiConstants.violationSecurityLevelEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final securityLevelsJson = data['securityLevels'] as List<dynamic>;

        final models = securityLevelsJson
            .map((json) => ViolationSecurityLevelModel.fromJson(json as Map<String, dynamic>))
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
