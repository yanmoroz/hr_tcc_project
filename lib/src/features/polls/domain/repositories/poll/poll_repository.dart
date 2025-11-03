import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class PollRepository {
  Future<Result<List<Poll>>> getPolls({int? status, required int page});
}
