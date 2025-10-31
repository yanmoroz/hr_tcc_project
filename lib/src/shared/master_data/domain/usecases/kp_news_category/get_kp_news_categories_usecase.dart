import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpNewsCategoriesUsecase {
  final KpNewsCategoryRepository kpNewsCategoryRepository;

  GetKpNewsCategoriesUsecase(this.kpNewsCategoryRepository);

  Future<Either<NetworkException, List<KpNewsCategory>>> call() async {
    return await kpNewsCategoryRepository.getKpNewsCategories();
  }
}
