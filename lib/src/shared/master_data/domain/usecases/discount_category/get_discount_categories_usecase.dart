import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetDiscountCategoriesUsecase {
  final DiscountCategoryRepository discountCategoryRepository;

  GetDiscountCategoriesUsecase(this.discountCategoryRepository);

  Future<Either<NetworkException, List<DiscountCategory>>> call() async {
    return await discountCategoryRepository.getDiscountCategories();
  }
}
