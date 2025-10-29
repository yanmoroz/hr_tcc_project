import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetReferralProgramVacationsUsecase {
  final ReferralProgramVacationRepository referralProgramVacationRepository;

  GetReferralProgramVacationsUsecase(this.referralProgramVacationRepository);

  Future<Either<NetworkException, List<ReferralProgramVacation>>> call() async {
    return await referralProgramVacationRepository.getReferralProgramVacations();
  }
}
