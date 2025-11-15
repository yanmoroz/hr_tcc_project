import '../../../../core/types/result.dart';

import '../../../../core/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';

class KpNewsCategoryRepositoryImpl with BaseRepository implements KpNewsCategoryRepository {
  final KpNewsCategoryRemoteDataSource _remoteDataSource;

  KpNewsCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpNewsCategory>>> getKpNewsCategories() async {
    final result = await _remoteDataSource.getKpNewsCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
