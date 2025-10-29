import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetReferralProgramCandidatesUsecase {
  final ReferralProgramCandidateRepository referralProgramCandidateRepository;

  GetReferralProgramCandidatesUsecase(this.referralProgramCandidateRepository);

  Future<Either<NetworkException, List<ReferralProgramCandidate>>> call() async {
    return await referralProgramCandidateRepository.getReferralProgramCandidates();
  }
}
