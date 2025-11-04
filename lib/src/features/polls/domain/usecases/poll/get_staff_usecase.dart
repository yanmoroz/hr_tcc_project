import '../../../../../core/types/result.dart';
import '../../domain.dart';

class GetStaffUsecase {
  final StaffRepository staffRepository;

  GetStaffUsecase(this.staffRepository);

  Future<Result<List<StaffItem>>> call({required StaffTarget target, String? search}) async {
    return await staffRepository.getStaff(target: target, search: search);
  }
}
