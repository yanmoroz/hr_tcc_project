import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpDiscountCategoriesUsecase {
  final KpDiscountCategoryRepository kpDiscountCategoryRepository;

  GetKpDiscountCategoriesUsecase(this.kpDiscountCategoryRepository);

  Future<Either<NetworkException, List<KpDiscountCategory>>> call() async {
    return await kpDiscountCategoryRepository.getKpDiscountCategories();
  }
}
