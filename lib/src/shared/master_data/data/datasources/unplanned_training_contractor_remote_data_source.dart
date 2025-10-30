import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/network/network_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/models.dart';

abstract class UnplannedTrainingContractorRemoteDataSource {
  Future<Either<NetworkException, List<UnplannedTrainingContractorModel>>> getUnplannedTrainingContractors();
}

class UnplannedTrainingContractorRemoteDataSourceImpl implements UnplannedTrainingContractorRemoteDataSource {
  final ApiClient _apiClient;

  UnplannedTrainingContractorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<UnplannedTrainingContractorModel>>> getUnplannedTrainingContractors() async {
    try {
      final response = await _apiClient.get(ApiConstants.unplannedTrainingContractorEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final contractorsJson = data['contractors'] as List<dynamic>;

        final models = contractorsJson
            .map((json) => UnplannedTrainingContractorModel.fromJson(json as Map<String, dynamic>))
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
