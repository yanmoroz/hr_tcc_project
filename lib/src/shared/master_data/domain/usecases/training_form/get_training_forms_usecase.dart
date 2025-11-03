import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetTrainingFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingFormsUsecase(this.coreDictionariesRepository);

  Future<Result<List<TrainingForm>>> call() async {
    return await coreDictionariesRepository.getTrainingForms();
  }
}
