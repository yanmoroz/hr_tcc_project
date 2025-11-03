import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetPollDetailUsecase {
  final PollDetailRepository pollDetailRepository;

  GetPollDetailUsecase(this.pollDetailRepository);

  Future<Result<PollDetail>> call(int id) async {
    return await pollDetailRepository.getPollDetail(id);
  }
}
