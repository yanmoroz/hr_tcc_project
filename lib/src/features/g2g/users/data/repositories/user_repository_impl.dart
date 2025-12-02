import '../../../../../core/base_types/base_repository.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../domain/domain.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/responses/address_book_user_model.dart';
import '../models/responses/user_model.dart';

class UserRepositoryImpl with BaseRepository implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<User>>> getUsers({
    required SystemType systemType,
    String? search,
  }) async {
    final result = await _remoteDataSource.getUsers(
      systemType: systemType,
      search: search,
    );
    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Future<Result<List<AddressBookUser>>> getAddressBook({
    String? organizationCode,
    String? departmentCode,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    final result = await _remoteDataSource.getAddressBook(
      organizationCode: organizationCode,
      departmentCode: departmentCode,
      search: search,
      page: page,
      pageSize: pageSize,
    );
    return result.map(
      (response) =>
          response.employees.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<AddressBookUser>> getCurrentUserInfo() async {
    final result = await _remoteDataSource.getCurrentUserInfo();
    return result.map((model) => model.toDomain());
  }
}
