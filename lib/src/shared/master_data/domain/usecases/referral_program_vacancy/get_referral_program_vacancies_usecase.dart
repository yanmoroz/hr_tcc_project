import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetReferralProgramVacanciesUsecase {
  final ReferralProgramVacancyRepository referralProgramVacancyRepository;

  GetReferralProgramVacanciesUsecase(this.referralProgramVacancyRepository);

  Future<Result<List<ReferralProgramVacancy>>> call() async {
    return await referralProgramVacancyRepository.getReferralProgramVacancies();
  }
}
