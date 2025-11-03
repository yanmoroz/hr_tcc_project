import 'package:hr_tcc_project/src/core/data/base_repository.dart';
import 'package:hr_tcc_project/src/core/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/users/data/datasources/user_remote_data_source.dart';
import 'package:hr_tcc_project/src/features/users/data/models/user_model.dart';
import 'package:hr_tcc_project/src/features/users/domain/entities/user.dart';
import 'package:hr_tcc_project/src/features/users/domain/repositories/user_repository.dart';

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
}
