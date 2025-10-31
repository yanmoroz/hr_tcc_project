import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class KpDiscountSourceRepository {
  Future<Either<NetworkException, List<KpDiscountSource>>> getKpDiscountSources();
}
