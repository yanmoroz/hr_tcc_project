import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetViolationSecurityLevelsUsecase {
  final ViolationSecurityLevelRepository violationSecurityLevelRepository;

  GetViolationSecurityLevelsUsecase(this.violationSecurityLevelRepository);

  Future<Result<List<ViolationSecurityLevel>>> call() async {
    return await violationSecurityLevelRepository.getViolationSecurityLevels();
  }
}
