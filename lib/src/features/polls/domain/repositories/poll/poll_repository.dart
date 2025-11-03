import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class PollRepository {
  Future<Result<List<Poll>>> getPolls({int? status, required int page});
}
