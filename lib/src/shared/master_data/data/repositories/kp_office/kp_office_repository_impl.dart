import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpOfficeRepositoryImpl with BaseRepository implements KpOfficeRepository {
  final KpOfficeRemoteDataSource _remoteDataSource;

  KpOfficeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpOffice>>> getKpOffices() async {
    final result = await _remoteDataSource.getKpOffices();

    return mapResultList(result, (model) => model.toDomain());
  }
}
