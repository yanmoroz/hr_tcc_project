import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/system_type.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

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
