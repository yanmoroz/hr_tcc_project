import '../../../../core/types/result.dart';

import '../../../../core/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';

class KpDiscountSourceRepositoryImpl with BaseRepository implements KpDiscountSourceRepository {
  final KpDiscountSourceRemoteDataSource _remoteDataSource;

  KpDiscountSourceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources() async {
    final result = await _remoteDataSource.getKpDiscountSources();

    return mapResultList(result, (model) => model.toDomain());
  }
}
