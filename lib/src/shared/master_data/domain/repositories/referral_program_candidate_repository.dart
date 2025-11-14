import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class ReferralProgramCandidateRepository {
  Future<Result<List<ReferralProgramCandidate>>> getReferralProgramCandidates();
}
