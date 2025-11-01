import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpDiscountCategoryRepositoryImpl with BaseRepository implements KpDiscountCategoryRepository {
  final KpDiscountCategoryRemoteDataSource _remoteDataSource;

  KpDiscountCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpDiscountCategory>>> getKpDiscountCategories() async {
    final result = await _remoteDataSource.getKpDiscountCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
