import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class UnplannedTrainingContractorRepositoryImpl with BaseRepository implements UnplannedTrainingContractorRepository {
  final UnplannedTrainingContractorRemoteDataSource _remoteDataSource;

  UnplannedTrainingContractorRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<UnplannedTrainingContractor>>> getUnplannedTrainingContractors() async {
    final result = await _remoteDataSource.getUnplannedTrainingContractors();

    return mapResultList(result, (model) => model.toDomain());
  }
}
