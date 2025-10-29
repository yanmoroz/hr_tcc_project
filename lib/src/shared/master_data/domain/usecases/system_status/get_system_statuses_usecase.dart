import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetSystemStatusesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusesUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<SystemStatus>>> call() async {
    return await coreDictionariesRepository.getSystemStatuses();
  }
}
