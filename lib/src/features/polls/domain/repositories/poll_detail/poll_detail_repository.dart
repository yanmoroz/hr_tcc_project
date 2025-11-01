import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class PollDetailRepository {
  Future<Either<NetworkException, PollDetail>> getPollDetail(int id);
  Future<Either<NetworkException, void>> submitPollAnswers({required int pollId, required PollAnswersRequest request});
}
