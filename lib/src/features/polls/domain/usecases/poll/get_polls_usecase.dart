import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetPollsUsecase {
  final PollRepository pollRepository;

  GetPollsUsecase(this.pollRepository);

  Future<Result<List<Poll>>> call({int? status, required int page}) async {
    return await pollRepository.getPolls(status: status, page: page);
  }
}
