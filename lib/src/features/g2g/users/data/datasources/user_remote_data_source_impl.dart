import '../../../../../core/base_types/result.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../models/responses/address_book_response_model.dart';
import '../models/responses/address_book_user_model.dart';
import '../models/responses/user_model.dart';
import 'user_remote_data_source.dart';

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
        final users = data['users'] as List;
        return users
            .map(
              (userJson) =>
                  UserModel.fromJson(userJson as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<AddressBookResponseModel>> getAddressBook({
    String? organizationCode,
    String? departmentCode,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        };
        if (organizationCode != null && organizationCode.isNotEmpty) {
          queryParameters['organizationCode'] = organizationCode;
        }
        if (departmentCode != null && departmentCode.isNotEmpty) {
          queryParameters['departmentCode'] = departmentCode;
        }
        if (search != null && search.isNotEmpty) {
          queryParameters['search'] = search;
        }
        return _apiClient.get(
          ApiConstants.addressBookEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return AddressBookResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<AddressBookUserModel>> getCurrentUserInfo() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.get(ApiConstants.currentUserEndpoint);
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return AddressBookUserModel.fromJson(data);
      },
    );
  }
}
