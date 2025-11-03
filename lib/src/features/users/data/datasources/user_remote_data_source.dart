import 'package:hr_tcc_project/src/core/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/users/data/models/get_users_response.dart';
import 'package:hr_tcc_project/src/features/users/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<Result<List<UserModel>>> getUsers({
    required SystemType systemType,
    String? search,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<UserModel>>> getUsers({
    required SystemType systemType,
    String? search,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, String>{
          'systemType': systemType.value,
        };
        if (search != null && search.isNotEmpty) {
          queryParameters['search'] = search;
        }
        return _apiClient.get(
          ApiConstants.usersEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final getUsersResponse = GetUsersResponse.fromJson(data);
        return getUsersResponse.users;
      },
    );
  }
}
