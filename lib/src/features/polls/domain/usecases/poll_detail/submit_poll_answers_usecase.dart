import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class SubmitPollAnswersUsecase {
  final PollDetailRepository pollDetailRepository;

  SubmitPollAnswersUsecase(this.pollDetailRepository);

  Future<Either<NetworkException, void>> call({required int pollId, required PollAnswersRequest request}) async {
    return await pollDetailRepository.submitPollAnswers(pollId: pollId, request: request);
  }
}
