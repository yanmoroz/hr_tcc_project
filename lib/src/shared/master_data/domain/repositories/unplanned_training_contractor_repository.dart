import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class UnplannedTrainingContractorRepository {
  Future<Result<List<UnplannedTrainingContractor>>> getUnplannedTrainingContractors();
}
