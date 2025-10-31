import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class KpNewsCategoryRepository {
  Future<Either<NetworkException, List<KpNewsCategory>>> getKpNewsCategories();
}
