import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTrainingTypesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingTypesUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<TrainingType>>> call() async {
    return await coreDictionariesRepository.getTrainingTypes();
  }
}
