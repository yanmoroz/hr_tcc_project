import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTrainingFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingFormsUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<TrainingForm>>> call() async {
    return await coreDictionariesRepository.getTrainingForms();
  }
}
