import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetAlpinaDigitalPrevAccessesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetAlpinaDigitalPrevAccessesUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<AlpinaDigitalPrevAccess>>> call() async {
    return await coreDictionariesRepository.getAlpinaDigitalPrevAccess();
  }
}
