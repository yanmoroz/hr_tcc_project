import 'package:hr_tcc_project/src/shared/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/features/users/domain/entities/user.dart';

abstract class UserRepository {
  Future<Result<List<User>>> getUsers({
    required SystemType systemType,
    String? search,
  });
}
