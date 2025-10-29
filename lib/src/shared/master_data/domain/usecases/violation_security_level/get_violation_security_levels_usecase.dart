import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetViolationSecurityLevelsUsecase {
  final ViolationSecurityLevelRepository violationSecurityLevelRepository;

  GetViolationSecurityLevelsUsecase(this.violationSecurityLevelRepository);

  Future<Either<NetworkException, List<ViolationSecurityLevel>>> call() async {
    return await violationSecurityLevelRepository.getViolationSecurityLevels();
  }
}
