import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTrainingMonthsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTrainingMonthsUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<TrainingMonth>>> call() async {
    return await coreDictionariesRepository.getTrainingMonths();
  }
}
