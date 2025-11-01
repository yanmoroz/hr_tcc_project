import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetPollsUsecase {
  final PollRepository pollRepository;

  GetPollsUsecase(this.pollRepository);

  Future<Either<NetworkException, List<Poll>>> call({int? status, required int page}) async {
    return await pollRepository.getPolls(status: status, page: page);
  }
}
