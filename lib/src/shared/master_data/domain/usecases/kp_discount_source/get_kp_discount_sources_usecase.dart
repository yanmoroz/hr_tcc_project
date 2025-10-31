import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpDiscountSourcesUsecase {
  final KpDiscountSourceRepository kpDiscountSourceRepository;

  GetKpDiscountSourcesUsecase(this.kpDiscountSourceRepository);

  Future<Either<NetworkException, List<KpDiscountSource>>> call() async {
    return await kpDiscountSourceRepository.getKpDiscountSources();
  }
}
