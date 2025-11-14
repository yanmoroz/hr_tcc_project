import '../../../../core/types/result.dart';

import '../domain.dart';

class GetTrainingTypesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingTypesUsecase(this.coreDictionariesRepository);

  Future<Result<List<TrainingType>>> call() async {
    return await coreDictionariesRepository.getTrainingTypes();
  }
}
