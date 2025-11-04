import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/discount.dart';
import '../repositories/discount_repository.dart';

class GetDiscountsUsecase {
  final DiscountRepository repository;

  GetDiscountsUsecase(this.repository);

  Future<Result<List<Discount>>> call({required int category, required int source, required int page}) async {
    return await repository.getDiscounts(category: category, source: source, page: page);
  }
}
