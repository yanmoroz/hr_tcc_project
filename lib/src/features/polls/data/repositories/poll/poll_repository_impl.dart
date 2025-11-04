import '../../../../../core/types/result.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

class PollRepositoryImpl with BaseRepository implements PollRepository {
  final PollRemoteDataSource _remoteDataSource;

  PollRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Poll>>> getPolls({int? status, required int page}) async {
    final result = await _remoteDataSource.getPolls(status: status, page: page);

    return mapResultList(result, (model) => model.toDomain());
  }
}
