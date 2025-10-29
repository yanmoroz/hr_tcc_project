import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetOfficesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetOfficesUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<Office>>> call() async {
    return await coreDictionariesRepository.getOffices();
  }
}
