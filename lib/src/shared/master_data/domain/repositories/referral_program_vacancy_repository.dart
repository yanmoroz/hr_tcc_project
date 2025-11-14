import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class ReferralProgramVacancyRepository {
  Future<Result<List<ReferralProgramVacancy>>> getReferralProgramVacancies();
}
