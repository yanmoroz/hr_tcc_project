import '../../../../core/base_types/result.dart';
import '../entities/address_book_user.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserInfoUsecase {
  final UserRepository userRepository;

  GetCurrentUserInfoUsecase(this.userRepository);

  Future<Result<AddressBookUser>> call() async {
    return await userRepository.getCurrentUserInfo();
  }
}
