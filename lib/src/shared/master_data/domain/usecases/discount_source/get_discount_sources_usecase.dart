import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetDiscountSourcesUsecase {
  final DiscountSourceRepository discountSourceRepository;

  GetDiscountSourcesUsecase(this.discountSourceRepository);

  Future<Either<NetworkException, List<DiscountSource>>> call() async {
    return await discountSourceRepository.getDiscountSources();
  }
}
