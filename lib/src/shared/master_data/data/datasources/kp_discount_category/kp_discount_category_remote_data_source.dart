import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpDiscountCategoryRemoteDataSource {
  Future<Either<NetworkException, List<KpDiscountCategoryModel>>> getKpDiscountCategories();
}

class KpDiscountCategoryRemoteDataSourceImpl implements KpDiscountCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpDiscountCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpDiscountCategoryModel>>> getKpDiscountCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.kpDiscountCategoryEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final discountCategoriesJson = data['discountCategories'] as List<dynamic>;

        final models = discountCategoriesJson
            .map((json) => KpDiscountCategoryModel.fromJson(json as Map<String, dynamic>))
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
