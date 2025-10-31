import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpDiscountSourceRemoteDataSource {
  Future<Either<NetworkException, List<KpDiscountSourceModel>>> getKpDiscountSources();
}

class KpDiscountSourceRemoteDataSourceImpl implements KpDiscountSourceRemoteDataSource {
  final ApiClient _apiClient;

  KpDiscountSourceRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpDiscountSourceModel>>> getKpDiscountSources() async {
    try {
      final response = await _apiClient.get(ApiConstants.kpDiscountSourceEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final discountSourcesJson = data['discountSources'] as List<dynamic>;

        final models = discountSourcesJson
            .map((json) => KpDiscountSourceModel.fromJson(json as Map<String, dynamic>))
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
