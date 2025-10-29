import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetApplicationFormGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormGroupsUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<ApplicationFormGroup>>> call() async {
    return await coreDictionariesRepository.getApplicationFormGroups();
  }
}
