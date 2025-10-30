import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetReferralProgramVacanciesUsecase {
  final ReferralProgramVacancyRepository referralProgramVacancyRepository;

  GetReferralProgramVacanciesUsecase(this.referralProgramVacancyRepository);

  Future<Either<NetworkException, List<ReferralProgramVacancy>>> call() async {
    return await referralProgramVacancyRepository.getReferralProgramVacancies();
  }
}
