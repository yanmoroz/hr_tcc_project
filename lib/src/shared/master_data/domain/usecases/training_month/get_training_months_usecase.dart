import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTrainingMonthsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingMonthsUsecase(this.coreDictionariesRepository);

  Future<Result<List<TrainingMonth>>> call() async {
    return await coreDictionariesRepository.getTrainingMonths();
  }
}
