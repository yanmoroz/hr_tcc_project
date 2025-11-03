import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class StaffRepositoryImpl with BaseRepository implements StaffRepository {
  final StaffRemoteDataSource _remoteDataSource;

  StaffRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<StaffItem>>> getStaff({required StaffTarget target, String? search}) async {
    final result = await _remoteDataSource.getStaff(target: target, search: search);

    return mapResultList(result, (model) => model.toDomain());
  }
}
