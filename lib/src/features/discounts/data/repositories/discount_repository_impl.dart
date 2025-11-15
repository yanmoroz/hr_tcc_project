import 'package:hr_tcc_project/src/core/base_types/base_repository.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../domain/entities/discount.dart';
import '../../domain/entities/discount_detail.dart';
import '../../domain/entities/kp_discount_category.dart';
import '../../domain/entities/kp_discount_source.dart';
import '../../domain/repositories/discount_repository.dart';
import '../datasources/discount_remote_data_source.dart';
import '../models/discount_detail_model.dart';
import '../models/kp_discount_category_model.dart';
import '../models/kp_discount_source_model.dart';
import '../models/discount_model.dart';

class DiscountRepositoryImpl with BaseRepository implements DiscountRepository {
  final DiscountRemoteDataSource _remoteDataSource;

  DiscountRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Discount>>> getDiscounts({
    required int category,
    required int source,
    required int page,
  }) async {
    final result = await _remoteDataSource.getDiscounts(
      category: category,
      source: source,
      page: page,
    );
    return result.map(
      (response) =>
          response.discounts.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<DiscountDetail>> getDiscountDetail(int id) async {
    final result = await _remoteDataSource.getDiscountDetail(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<({int likeCount, bool like, int commentCount})>>
  getDiscountStats(int id) async {
    final result = await _remoteDataSource.getDiscountStats(id);
    return result.map(
      (response) => (
        likeCount: response.likeCount,
        like: response.like,
        commentCount: response.commentCount,
      ),
    );
  }

  @override
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources() async {
    final result = await _remoteDataSource.getKpDiscountSources();

    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories() async {
    final result = await _remoteDataSource.getKpDiscountCategories();

    return mapResultList(result, (model) => model.toDomain());
  }
}
