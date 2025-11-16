import '../../../../../core/base_types/result.dart';

abstract class DeleteCommentUsecase {
  Future<Result<List<int>>> call({
    required int entityId,
    required int commentId,
  });
}
