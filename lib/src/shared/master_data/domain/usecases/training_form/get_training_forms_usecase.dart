import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTrainingFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingFormsUsecase(this.coreDictionariesRepository);

  Future<Result<List<TrainingForm>>> call() async {
    return await coreDictionariesRepository.getTrainingForms();
  }
}
