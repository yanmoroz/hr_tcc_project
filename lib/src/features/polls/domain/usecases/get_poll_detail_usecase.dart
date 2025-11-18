import '../../../../core/base_types/result.dart';
import '../domain.dart';

class GetPollDetailUsecase {
  final PollRepository pollRepository;

  GetPollDetailUsecase(this.pollRepository);

  Future<Result<PollDetail>> call(int id) async {
    return await pollRepository.getPollDetail(id);
  }
}
