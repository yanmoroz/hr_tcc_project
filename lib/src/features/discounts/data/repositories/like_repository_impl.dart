import 'package:hr_tcc_project/src/core/data/base_repository.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../../domain/domain.dart';
import '../datasources/like_remote_data_source.dart';

class LikeRepositoryImpl with BaseRepository implements LikeRepository {
  final LikeRemoteDataSource _remoteDataSource;

  LikeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<bool>> toggleDiscountLike(int discountId) async {
    final result = await _remoteDataSource.toggleDiscountLike(discountId);
    return mapResult(result, (response) => response.like);
  }

  @override
  Future<Result<bool>> toggleCommentLike({
    required int discountId,
    required int commentId,
  }) async {
    final result = await _remoteDataSource.toggleCommentLike(discountId, commentId);
    return mapResult(result, (response) => response.like);
  }
}
