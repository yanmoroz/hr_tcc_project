import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpOfficeRemoteDataSource {
  Future<Either<NetworkException, List<KpOfficeModel>>> getKpOffices();
}

class KpOfficeRemoteDataSourceImpl implements KpOfficeRemoteDataSource {
  final ApiClient _apiClient;

  KpOfficeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpOfficeModel>>> getKpOffices() async {
    try {
      final response = await _apiClient.get(ApiConstants.kpOfficeEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final officesJson = data['offices'] as List<dynamic>;

        final models = officesJson.map((json) => KpOfficeModel.fromJson(json as Map<String, dynamic>)).toList();

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
