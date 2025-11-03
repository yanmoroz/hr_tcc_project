import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetReferralProgramCandidatesUsecase {
  final ReferralProgramCandidateRepository referralProgramCandidateRepository;

  GetReferralProgramCandidatesUsecase(this.referralProgramCandidateRepository);

  Future<Result<List<ReferralProgramCandidate>>> call() async {
    return await referralProgramCandidateRepository.getReferralProgramCandidates();
  }
}
