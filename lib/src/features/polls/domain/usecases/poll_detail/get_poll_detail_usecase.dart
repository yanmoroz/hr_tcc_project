import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetPollDetailUsecase {
  final PollDetailRepository pollDetailRepository;

  GetPollDetailUsecase(this.pollDetailRepository);

  Future<Either<NetworkException, PollDetail>> call(int id) async {
    return await pollDetailRepository.getPollDetail(id);
  }
}
