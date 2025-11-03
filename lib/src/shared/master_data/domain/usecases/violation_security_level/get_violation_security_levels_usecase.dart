import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetViolationSecurityLevelsUsecase {
  final ViolationSecurityLevelRepository violationSecurityLevelRepository;

  GetViolationSecurityLevelsUsecase(this.violationSecurityLevelRepository);

  Future<Result<List<ViolationSecurityLevel>>> call() async {
    return await violationSecurityLevelRepository.getViolationSecurityLevels();
  }
}
