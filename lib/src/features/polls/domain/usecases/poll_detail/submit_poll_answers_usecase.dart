import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class SubmitPollAnswersUsecase {
  final PollDetailRepository pollDetailRepository;

  SubmitPollAnswersUsecase(this.pollDetailRepository);

  Future<Result<void>> call({required int pollId, required PollAnswersRequest request}) async {
    return await pollDetailRepository.submitPollAnswers(pollId: pollId, request: request);
  }
}
