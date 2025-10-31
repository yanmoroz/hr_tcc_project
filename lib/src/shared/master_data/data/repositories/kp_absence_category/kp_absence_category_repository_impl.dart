import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpAbsenceCategoryRepositoryImpl implements KpAbsenceCategoryRepository {
  final KpAbsenceCategoryRemoteDataSource _remoteDataSource;

  KpAbsenceCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpAbsenceCategory>>> getKpAbsenceCategories() async {
    final result = await _remoteDataSource.getKpAbsenceCategories();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
