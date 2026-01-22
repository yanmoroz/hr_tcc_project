import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/system_type.dart';
import '../entities/address_book_user.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Result<List<User>>> getUsers({
    required SystemType systemType,
    String? search,
  });

  Future<Result<List<AddressBookUser>>> getAddressBook({
    String? organizationCode,
    String? departmentCode,
    String? search,
    required int page,
    required int pageSize,
  });

  Future<Result<AddressBookUser>> getCurrentUserInfo();
}
