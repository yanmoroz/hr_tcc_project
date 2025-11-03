import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpAbsenceCategoryRepositoryImpl with BaseRepository implements KpAbsenceCategoryRepository {
  final KpAbsenceCategoryRemoteDataSource _remoteDataSource;

  KpAbsenceCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories() async {
    final result = await _remoteDataSource.getKpAbsenceCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
