import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetApplicationFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormsUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<ApplicationForm>>> call() async {
    return await coreDictionariesRepository.getApplicationForms();
  }
}
