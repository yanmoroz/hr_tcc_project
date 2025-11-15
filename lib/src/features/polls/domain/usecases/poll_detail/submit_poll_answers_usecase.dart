import '../../../../../core/base_types/result.dart';
import '../../domain.dart';

class SubmitPollAnswersUsecase {
  final PollDetailRepository pollDetailRepository;

  SubmitPollAnswersUsecase(this.pollDetailRepository);

  Future<Result<void>> call({
    required int pollId,
    required PollAnswersRequest request,
  }) async {
    return await pollDetailRepository.submitPollAnswers(
      pollId: pollId,
      request: request,
    );
  }
}
