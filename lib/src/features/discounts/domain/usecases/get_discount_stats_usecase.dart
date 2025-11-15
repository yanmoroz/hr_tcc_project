import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../repositories/discount_repository.dart';

class GetDiscountStatsUsecase {
  final DiscountRepository repository;

  GetDiscountStatsUsecase(this.repository);

  Future<Result<({int likeCount, bool like, int commentCount})>> call(
    int id,
  ) async {
    return await repository.getDiscountStats(id);
  }
}
