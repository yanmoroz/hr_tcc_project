import 'package:hr_tcc_project/src/core/base_types/result.dart';

/// Abstract interface for toggling comment likes.
/// Feature-specific implementations capture entityId in constructor
/// and only expose commentId to the CommentsBloc.
abstract class ToggleCommentLikeUsecase {
  Future<Result<bool>> call({required int entityId, required int commentId});
}
