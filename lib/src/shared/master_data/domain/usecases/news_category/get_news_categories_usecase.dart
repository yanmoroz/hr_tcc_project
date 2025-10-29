import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetNewsCategoriesUsecase {
  final NewsCategoryRepository newsCategoryRepository;

  GetNewsCategoriesUsecase(this.newsCategoryRepository);

  Future<Either<NetworkException, List<NewsCategory>>> call() async {
    return await newsCategoryRepository.getNewsCategories();
  }
}
