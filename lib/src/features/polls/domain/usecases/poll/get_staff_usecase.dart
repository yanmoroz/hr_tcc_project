import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetStaffUsecase {
  final StaffRepository staffRepository;

  GetStaffUsecase(this.staffRepository);

  Future<Either<NetworkException, List<StaffItem>>> call({required StaffTarget target, String? search}) async {
    return await staffRepository.getStaff(target: target, search: search);
  }
}
