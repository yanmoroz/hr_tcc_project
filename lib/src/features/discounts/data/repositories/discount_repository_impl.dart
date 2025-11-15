import 'package:hr_tcc_project/src/core/base_repository.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../../domain/domain.dart';
import '../data.dart';

class DiscountRepositoryImpl with BaseRepository implements DiscountRepository {
  final DiscountRemoteDataSource _remoteDataSource;

  DiscountRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Discount>>> getDiscounts({required int category, required int source, required int page}) async {
    final result = await _remoteDataSource.getDiscounts(category: category, source: source, page: page);
    return mapResult(result, (response) => response.discounts.map((model) => model.toDomain()).toList());
  }

  @override
  Future<Result<DiscountDetail>> getDiscountDetail(int id) async {
    final result = await _remoteDataSource.getDiscountDetail(id);
    return mapResult(result, (model) => model.toDomain());
  }

  @override
  Future<Result<({int likeCount, bool like, int commentCount})>> getDiscountStats(int id) async {
    final result = await _remoteDataSource.getDiscountStats(id);
    return mapResult(
      result,
      (response) => (likeCount: response.likeCount, like: response.like, commentCount: response.commentCount),
    );
  }
}
