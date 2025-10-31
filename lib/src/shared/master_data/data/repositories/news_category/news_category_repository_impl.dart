import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class NewsCategoryRepositoryImpl implements NewsCategoryRepository {
  final NewsCategoryRemoteDataSource _remoteDataSource;

  NewsCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<NewsCategory>>> getNewsCategories() async {
    final result = await _remoteDataSource.getNewsCategories();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
