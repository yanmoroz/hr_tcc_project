import '../../../../../core/base_types/result.dart';
import '../../entities/comment.dart';

abstract class GetCommentsUsecase {
  Future<Result<List<Comment>>> call(int entityId);
}
