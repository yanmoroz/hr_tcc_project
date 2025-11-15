import '../../../../../core/base_types/result.dart';
import '../../domain.dart';

class GetPollsUsecase {
  final PollRepository pollRepository;

  GetPollsUsecase(this.pollRepository);

  Future<Result<List<Poll>>> call({int? status, required int page}) async {
    return await pollRepository.getPolls(status: status, page: page);
  }
}
