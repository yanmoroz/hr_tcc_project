import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class ReferralProgramVacancyRepository {
  Future<Result<List<ReferralProgramVacancy>>> getReferralProgramVacancies();
}
