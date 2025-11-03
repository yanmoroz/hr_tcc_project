import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class ReferralProgramVacancyRepositoryImpl with BaseRepository implements ReferralProgramVacancyRepository {
  final ReferralProgramVacancyRemoteDataSource _remoteDataSource;

  ReferralProgramVacancyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ReferralProgramVacancy>>> getReferralProgramVacancies() async {
    final result = await _remoteDataSource.getReferralProgramVacancies();

    return mapResultList(result, (model) => model.toDomain());
  }
}
