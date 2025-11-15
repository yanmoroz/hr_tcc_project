import '../../../../../core/base_types/result.dart';

import '../../domain.dart';

abstract class PollDetailRepository {
  Future<Result<PollDetail>> getPollDetail(int id);
  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequest request,
  });
}
