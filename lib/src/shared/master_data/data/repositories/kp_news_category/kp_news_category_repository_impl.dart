import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpNewsCategoryRepositoryImpl with BaseRepository implements KpNewsCategoryRepository {
  final KpNewsCategoryRemoteDataSource _remoteDataSource;

  KpNewsCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpNewsCategory>>> getKpNewsCategories() async {
    final result = await _remoteDataSource.getKpNewsCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
