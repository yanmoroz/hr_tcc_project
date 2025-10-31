import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class DiscountCategoryRepositoryImpl implements DiscountCategoryRepository {
  final DiscountCategoryRemoteDataSource _remoteDataSource;

  DiscountCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<DiscountCategory>>> getDiscountCategories() async {
    final result = await _remoteDataSource.getDiscountCategories();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
