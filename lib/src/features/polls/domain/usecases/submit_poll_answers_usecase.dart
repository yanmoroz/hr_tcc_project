import '../../../../core/base_types/result.dart';
import '../domain.dart';

class SubmitPollAnswersUsecase {
  final PollRepository pollRepository;

  SubmitPollAnswersUsecase(this.pollRepository);

  Future<Result<void>> call({
    required int pollId,
    required PollAnswersRequest request,
  }) async {
    return await pollRepository.submitPollAnswers(
      pollId: pollId,
      request: request,
    );
  }
}
