import 'package:hr_tcc_project/src/core/base_types/result.dart';

abstract class LikeRepository {
  Future<Result<bool>> toggleEntityLike(int entityId);

  Future<Result<bool>> toggleCommentLike({
    required int entityId,
    required int commentId,
  });
}
