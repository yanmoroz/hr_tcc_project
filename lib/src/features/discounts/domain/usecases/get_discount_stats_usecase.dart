import '../../../../core/base_types/result.dart';
import '../repositories/discount_repository.dart';
import '../results/get_discount_stats_result.dart';

class GetDiscountStatsUsecase {
  final DiscountRepository repository;

  GetDiscountStatsUsecase(this.repository);

  Future<Result<GetDiscountStatsResult>> call(int id) async {
    return await repository.getDiscountStats(id);
  }
}
