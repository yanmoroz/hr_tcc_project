import '../../../../core/types/result.dart';

import '../../../../core/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';

class ReferralProgramVacancyRepositoryImpl with BaseRepository implements ReferralProgramVacancyRepository {
  final ReferralProgramVacancyRemoteDataSource _remoteDataSource;

  ReferralProgramVacancyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ReferralProgramVacancy>>> getReferralProgramVacancies() async {
    final result = await _remoteDataSource.getReferralProgramVacancies();

    return mapResultList(result, (model) => model.toDomain());
  }
}
