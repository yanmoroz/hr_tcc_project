import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class ReferralProgramCandidateRepository {
  Future<Result<List<ReferralProgramCandidate>>> getReferralProgramCandidates();
}
