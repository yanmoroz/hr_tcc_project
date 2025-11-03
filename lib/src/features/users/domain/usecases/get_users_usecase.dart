import 'package:hr_tcc_project/src/core/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/users/domain/entities/user.dart';
import 'package:hr_tcc_project/src/features/users/domain/repositories/user_repository.dart';

class GetUsersUsecase {
  final UserRepository userRepository;

  GetUsersUsecase(this.userRepository);

  Future<Result<List<User>>> call({
    required SystemType systemType,
    String? search,
  }) async {
    return await userRepository.getUsers(
      systemType: systemType,
      search: search,
    );
  }
}
