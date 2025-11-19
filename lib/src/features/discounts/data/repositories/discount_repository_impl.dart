import '../../../../core/base_types/base_repository.dart';
import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../datasources/discount_remote_data_source.dart';
import '../models/responses/discount_model.dart';
import '../models/responses/discount_detail_model.dart';
import '../models/responses/kp_discount_source_model.dart';
import '../models/responses/kp_discount_category_model.dart';

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
  Future<Result<GetDiscountStatsResult>> getDiscountStats(int id) async {
    final result = await _remoteDataSource.getDiscountStats(id);
    return result.map(
      (response) => GetDiscountStatsResult(
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

  @override
  Future<Result<bool>> toggleDiscountLike(int discountId) async {
    return await _remoteDataSource.toggleDiscountLike(discountId);
  }
}
