import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

class ViolationSecurityLevelRepositoryImpl with BaseRepository implements ViolationSecurityLevelRepository {
  final ViolationSecurityLevelRemoteDataSource _remoteDataSource;

  ViolationSecurityLevelRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ViolationSecurityLevel>>> getViolationSecurityLevels() async {
    final result = await _remoteDataSource.getViolationSecurityLevels();

    return mapResultList(result, (model) => model.toDomain());
  }
}
