import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/system_type.dart';
import '../models/address_book_response.dart';
import '../models/address_book_user_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<Result<List<UserModel>>> getUsers({
    required SystemType systemType,
    String? search,
  });

  Future<Result<AddressBookResponse>> getAddressBook({
    String? organizationCode,
    String? departmentCode,
    String? search,
    required int page,
    required int pageSize,
  });

  Future<Result<AddressBookUserModel>> getCurrentUserInfo();
}
