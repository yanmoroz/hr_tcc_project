import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpDiscountSourceRepositoryImpl with BaseRepository implements KpDiscountSourceRepository {
  final KpDiscountSourceRemoteDataSource _remoteDataSource;

  KpDiscountSourceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources() async {
    final result = await _remoteDataSource.getKpDiscountSources();

    return mapResultList(result, (model) => model.toDomain());
  }
}
