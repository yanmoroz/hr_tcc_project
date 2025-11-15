import 'package:hr_tcc_project/src/core/base_types/base_repository.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../../domain/domain.dart';
import '../datasources/like_remote_data_source.dart';

class LikeRepositoryImpl with BaseRepository implements LikeRepository {
  final LikeRemoteDataSource _remoteDataSource;

  LikeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<bool>> toggleEntityLike(int entityId) async {
    final result = await _remoteDataSource.toggleEntityLike(entityId);
    return mapResult(result, (response) => response.like);
  }

  @override
  Future<Result<bool>> toggleCommentLike({
    required int entityId,
    required int commentId,
  }) async {
    final result = await _remoteDataSource.toggleCommentLike(
      entityId,
      commentId,
    );
    return mapResult(result, (response) => response.like);
  }
}
