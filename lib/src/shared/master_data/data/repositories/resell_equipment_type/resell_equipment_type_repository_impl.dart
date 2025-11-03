import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class ResellEquipmentTypeRepositoryImpl with BaseRepository implements ResellEquipmentTypeRepository {
  final ResellEquipmentTypeRemoteDataSource _remoteDataSource;

  ResellEquipmentTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes() async {
    final result = await _remoteDataSource.getResellEquipmentTypes();

    return mapResultList(result, (model) => model.toDomain());
  }
}
