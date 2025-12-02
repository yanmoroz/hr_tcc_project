import '../../../../../core/base_types/result.dart';
import '../entities/address_book_user.dart';
import '../repositories/user_repository.dart';

class GetAddressBookUsecase {
  final UserRepository userRepository;

  GetAddressBookUsecase(this.userRepository);

  Future<Result<List<AddressBookUser>>> call({
    String? organizationCode,
    String? departmentCode,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    return await userRepository.getAddressBook(
      organizationCode: organizationCode,
      departmentCode: departmentCode,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
