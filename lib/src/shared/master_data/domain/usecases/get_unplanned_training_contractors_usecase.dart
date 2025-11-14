import '../../../../core/types/result.dart';

import '../domain.dart';

class GetUnplannedTrainingContractorsUsecase {
  final UnplannedTrainingContractorRepository unplannedTrainingContractorRepository;

  GetUnplannedTrainingContractorsUsecase(this.unplannedTrainingContractorRepository);

  Future<Result<List<UnplannedTrainingContractor>>> call() async {
    return await unplannedTrainingContractorRepository.getUnplannedTrainingContractors();
  }
}
