import '../../../../core/base_types/result.dart';
import '../domain.dart';

class GetStaffUsecase {
  final PollRepository pollRepository;

  GetStaffUsecase(this.pollRepository);

  Future<Result<List<StaffItem>>> call({
    required StaffTarget target,
    String? search,
  }) async {
    return await pollRepository.getStaff(target: target, search: search);
  }
}
