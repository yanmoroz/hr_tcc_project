import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class PollRepository {
  Future<Either<NetworkException, List<Poll>>> getPolls({int? status, required int page});
}
