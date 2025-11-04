import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

class KpDiscountCategoryRepositoryImpl with BaseRepository implements KpDiscountCategoryRepository {
  final KpDiscountCategoryRemoteDataSource _remoteDataSource;

  KpDiscountCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories() async {
    final result = await _remoteDataSource.getKpDiscountCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
