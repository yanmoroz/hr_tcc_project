import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class ViolationSecurityLevelRepositoryImpl implements ViolationSecurityLevelRepository {
  final ViolationSecurityLevelRemoteDataSource _remoteDataSource;

  ViolationSecurityLevelRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<ViolationSecurityLevel>>> getViolationSecurityLevels() async {
    final result = await _remoteDataSource.getViolationSecurityLevels();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
