import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpNewsCategoryRemoteDataSource {
  Future<Either<NetworkException, List<KpNewsCategoryModel>>> getKpNewsCategories();
}

class KpNewsCategoryRemoteDataSourceImpl implements KpNewsCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpNewsCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpNewsCategoryModel>>> getKpNewsCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.kpNewsCategoryEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newsCategoriesJson = data['newsCategories'] as List<dynamic>;

        final models = newsCategoriesJson
            .map((json) => KpNewsCategoryModel.fromJson(json as Map<String, dynamic>))
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
