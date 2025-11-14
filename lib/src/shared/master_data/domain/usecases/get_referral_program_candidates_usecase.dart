import '../../../../core/types/result.dart';

import '../domain.dart';

class GetReferralProgramCandidatesUsecase {
  final ReferralProgramCandidateRepository referralProgramCandidateRepository;

  GetReferralProgramCandidatesUsecase(this.referralProgramCandidateRepository);

  Future<Result<List<ReferralProgramCandidate>>> call() async {
    return await referralProgramCandidateRepository.getReferralProgramCandidates();
  }
}
