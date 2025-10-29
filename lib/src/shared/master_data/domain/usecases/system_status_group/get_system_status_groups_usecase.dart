import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetSystemStatusGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusGroupsUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<SystemStatusGroup>>> call() async {
    return await coreDictionariesRepository.getSystemStatusGroups();
  }
}
