import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../../entities/comment.dart';

abstract class AddCommentUsecase {
  Future<Result<Comment>> call({
    required int entityId,
    required String content,
    int? parent,
    List<int>? attachments,
  });
}
