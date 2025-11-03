import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetReferralProgramVacanciesUsecase {
  final ReferralProgramVacancyRepository referralProgramVacancyRepository;

  GetReferralProgramVacanciesUsecase(this.referralProgramVacancyRepository);

  Future<Result<List<ReferralProgramVacancy>>> call() async {
    return await referralProgramVacancyRepository.getReferralProgramVacancies();
  }
}
