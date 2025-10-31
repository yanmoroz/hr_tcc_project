import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpNewsCategoryRepositoryImpl implements KpNewsCategoryRepository {
  final KpNewsCategoryRemoteDataSource _remoteDataSource;

  KpNewsCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpNewsCategory>>> getKpNewsCategories() async {
    final result = await _remoteDataSource.getKpNewsCategories();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
