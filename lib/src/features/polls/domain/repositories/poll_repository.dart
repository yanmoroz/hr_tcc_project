import '../../../../core/base_types/result.dart';

import '../domain.dart';

abstract class PollRepository {
  Future<Result<List<Poll>>> getPolls({int? status, required int page});

  Future<Result<PollDetail>> getPollDetail(int id);

  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequest request,
  });

  Future<Result<List<StaffItem>>> getStaff({
    required StaffTarget target,
    String? search,
  });
}
