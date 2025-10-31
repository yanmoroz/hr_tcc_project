import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class DiscountSourceRemoteDataSource {
  Future<Either<NetworkException, List<DiscountSourceModel>>> getDiscountSources();
}

class DiscountSourceRemoteDataSourceImpl implements DiscountSourceRemoteDataSource {
  final ApiClient _apiClient;

  DiscountSourceRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<DiscountSourceModel>>> getDiscountSources() async {
    try {
      final response = await _apiClient.get(ApiConstants.discountSourceEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final discountSourcesJson = data['discountSources'] as List<dynamic>;

        final models = discountSourcesJson
            .map((json) => DiscountSourceModel.fromJson(json as Map<String, dynamic>))
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
