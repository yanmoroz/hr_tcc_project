import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpOfficeRepositoryImpl implements KpOfficeRepository {
  final KpOfficeRemoteDataSource _remoteDataSource;

  KpOfficeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpOffice>>> getKpOffices() async {
    final result = await _remoteDataSource.getKpOffices();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
