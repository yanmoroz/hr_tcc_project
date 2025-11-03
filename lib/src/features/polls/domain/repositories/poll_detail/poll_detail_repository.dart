import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class PollDetailRepository {
  Future<Result<PollDetail>> getPollDetail(int id);
  Future<Result<void>> submitPollAnswers({required int pollId, required PollAnswersRequest request});
}
