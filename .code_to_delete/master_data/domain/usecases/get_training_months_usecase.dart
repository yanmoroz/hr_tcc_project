import '../../../../core/types/result.dart';

import '../domain.dart';

class GetTrainingMonthsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingMonthsUsecase(this.coreDictionariesRepository);

  Future<Result<List<TrainingMonth>>> call() async {
    return await coreDictionariesRepository.getTrainingMonths();
  }
}
