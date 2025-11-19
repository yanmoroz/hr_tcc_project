import '../../../../core/base_types/result.dart';
import '../domain.dart';

class SubmitPollAnswersUsecase {
  final PollRepository pollRepository;

  SubmitPollAnswersUsecase(this.pollRepository);

  Future<Result<void>> call({
    required int pollId,
    required List<PollAnswer> answers,
  }) async {
    return await pollRepository.submitPollAnswers(
      pollId: pollId,
      answers: answers,
    );
  }
}
