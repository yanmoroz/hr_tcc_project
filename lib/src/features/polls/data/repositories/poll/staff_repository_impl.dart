import '../../../../../core/types/result.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

class StaffRepositoryImpl with BaseRepository implements StaffRepository {
  final StaffRemoteDataSource _remoteDataSource;

  StaffRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<StaffItem>>> getStaff({required StaffTarget target, String? search}) async {
    final result = await _remoteDataSource.getStaff(target: target, search: search);

    return mapResultList(result, (model) => model.toDomain());
  }
}
