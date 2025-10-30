import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/network/network_exception.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/data_sources.dart';
import '../models/models.dart';

class ResellEquipmentTypeRepositoryImpl implements ResellEquipmentTypeRepository {
  final ResellEquipmentTypeRemoteDataSource _remoteDataSource;

  ResellEquipmentTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<ResellEquipmentType>>> getResellEquipmentTypes() async {
    final result = await _remoteDataSource.getResellEquipmentTypes();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
